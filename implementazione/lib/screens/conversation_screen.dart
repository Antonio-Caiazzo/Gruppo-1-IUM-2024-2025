import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import '../constants/colors.dart';
import '../models/conversation.dart';
import 'conversations_student_screen.dart';
import '../widgets/student_bottom_nav_bar.dart';

class ConversationScreen extends StatefulWidget {
  final String characterName;
  final String characterImage;
  final String name;
  final String surname;
  final String classCode;
  final bool isReadOnly;
  final String? customTitle;
  final String? introMessage;
  final List<Map<String, String>>? messages;

  static List<Conversation> saved = [];
  static List<Conversation> shared = [];

  const ConversationScreen({
    super.key,
    required this.characterName,
    required this.characterImage,
    required this.name,
    required this.surname,
    required this.classCode,
    this.isReadOnly = false,
    this.customTitle,
    this.introMessage,
    this.messages,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _controller = TextEditingController();
  final FlutterTts flutterTts = FlutterTts();
  final List<Map<String, String>> _messages = [];
  bool _showMenu = false;

  @override
  void initState() {
    super.initState();
    if (widget.messages != null && widget.messages!.isNotEmpty) {
      _messages.addAll(widget.messages!);
    } else if (widget.introMessage == null) {
      // Aggiungi un messaggio introduttivo solo se non c'è una introMessage precompilata
      _messages.add({"role": "bot", "text": _intro()});
    }

    // Mostra la introMessage solo nella TextField, ma non aggiungerla come messaggio
    if (widget.introMessage != null) {
      _controller.text = widget.introMessage!;
    }
  }

  String _intro() {
    return widget.introMessage ??
        (widget.characterName.toLowerCase().contains('napoleone')
            ? 'Sono Napoleone Bonaparte, imperatore dei francesi. Chiedimi pure.'
            : 'Io sono Giulio Cesare, console di Roma. Cosa desideri sapere?');
  }

  void _sendMessage() async {
    final msg = _controller.text.trim();
    if (msg.isEmpty) return;
    setState(() {
      _messages.add({"role": "user", "text": msg});
      _controller.clear();
    });
    try {
      final reply = await _askOllama(msg);
      setState(() => _messages.add({"role": "bot", "text": reply}));
    } catch (_) {
      setState(() {
        _messages.add({
          "role": "bot",
          "text":
              "Sono Gaio Giulio Cesare, generale e console di Roma. Ora, giovane cittadino, sono qui per te: chiedimi quello che vuoi sapere!",
        });
      });
    }
  }

  Future<String> _askOllama(String prompt) async {
    final promptHead =
        """
Sei ${widget.characterName}, un vero personaggio storico realmente esistito.  
Ti trovi nel tuo tempo e stai dialogando con un giovane studente curioso.

Rispondi sempre in prima persona, con il linguaggio, la mentalità e i riferimenti tipici della tua epoca.  
Mostra la tua personalità, le tue convinzioni e il tuo ruolo storico (generale, imperatore, ecc.).

Non sei a conoscenza di eventi futuri rispetto alla tua epoca e non devi mai menzionare o fare riferimento a concetti moderni come tecnologia, intelligenza artificiale, social network o cose che non esistevano al tuo tempo.

Mantieni sempre il tono coerente con il tuo status storico: autorevole, riflessivo, diretto o militare, secondo il tuo personaggio.  
Non uscire mai dal ruolo, anche se ricevi domande strane o fuori contesto: rispondi con garbo dicendo che non puoi saperlo.

### Requisiti formali:
- Non usare mai virgolette (“ ” o " ") nella tua risposta  
- La risposta deve essere lunga tra le **20 e le 50 parole**
- Non dire mai che sei un’intelligenza artificiale o un assistente virtuale
- Rispondi utilizzando sempre emoji nelle tue risposte, per rendere il messaggio più chiaro, divertente o espressivo per uno studente.

### Contesto:
Stai parlando a uno studente interessato a conoscerti. Sii coinvolgente, chiaro e fedele al tuo tempo.

Domanda: {domanda_utente}  
Risposta:
""";

    final body = "$promptHead\nDomanda: $prompt\nRisposta:";
    final res = await http.post(
      Uri.parse('http://localhost:11434/api/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'model': 'llama3.2', 'prompt': body, 'stream': false}),
    );
    if (res.statusCode == 200) {
      return jsonDecode(res.body)['response'].toString().trim();
    }
    throw Exception();
  }

  Future<void> _speak(String t) async {
    await flutterTts.setLanguage('it-IT');
    await flutterTts.setPitch(1);
    await flutterTts.speak(t);
  }

  void _showInputDialog(bool share) {
    final c = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Inserisci il titolo della conversazione',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: c,
                decoration: const InputDecoration(hintText: 'Titolo'),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDF1818),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Annulla',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final t = c.text.trim();
                        if (t.isEmpty) return;
                        final preview = _messages
                            .map((m) => m['text'])
                            .join('\n');
                        final conv = Conversation(
                          title: t,
                          preview: preview.length > 80
                              ? '${preview.substring(0, 80).split('\n').first}...'
                              : preview,
                          imagePath:
                              widget.characterName.toLowerCase().contains(
                                'napoleone',
                              )
                              ? 'assets/generale.jpg'
                              : 'assets/caesar.png',
                          date: DateTime.now(),
                          sharedBy: share
                              ? '${widget.name} ${widget.surname}'
                              : null,
                          messages: List<Map<String, String>>.from(_messages),
                        );
                        if (share) {
                          ConversationScreen.shared.add(conv);
                        } else {
                          ConversationScreen.saved.add(conv);
                        }
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ConversationsStudentScreen(
                              name: widget.name,
                              surname: widget.surname,
                              classCode: widget.classCode,
                              highlightTitle: t,
                              isSharedTab: share,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                      ),
                      child: Text(
                        share ? 'Condividi' : 'Salva',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!widget.isReadOnly) {
      final hasUserMessage = _messages.any((m) => m['role'] == 'user');

      if (hasUserMessage) {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Attenzione!\nSe esci senza salvare o condividere, perderai la conversazione.',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context, false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Rimani in chat',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pop(context, true), // Conferma uscita
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDF1818),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Esci',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

        if (confirm == true) {
          Navigator.pop(context, true); // Domanda completata
        } else {
          // L’utente ha scelto di restare
        }

        return false;
      }

      // Se non ha mai scritto nulla → esce senza dialogo
      Navigator.pop(context, false); // Domanda incompleta
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _appBar(),
        body: _body(),
        bottomNavigationBar: widget.isReadOnly
            ? StudentBottomNavigationBar(
                currentIndex: -1,
                name: widget.name,
                surname: widget.surname,
                classCode: widget.classCode,
              )
            : null,
      ),
    );
  }

  AppBar _appBar() => AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.black),
      onPressed: () async {
        final res = await _onWillPop();
        if (res) Navigator.pop(context);
      },
    ),

    centerTitle: true,
    title: Text(
      widget.customTitle ?? widget.characterName,
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
    ),
    actions: [
      if (!widget.isReadOnly)
        IconButton(
          icon: Icon(_showMenu ? Icons.close : Icons.menu, color: Colors.black),
          onPressed: () => setState(() => _showMenu = !_showMenu),
        ),
    ],
  );

  Widget _body() => Stack(
    children: [
      Column(
        children: [
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(widget.characterImage, height: 160),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final m = _messages[i];
                return m['role'] == 'user'
                    ? _userMsg(m['text']!)
                    : _botMsg(m['text']!);
              },
            ),
          ),
          _inputArea(),
        ],
      ),
      if (_showMenu && !widget.isReadOnly)
        Positioned(
          top: 12,
          right: 12,
          child: Column(
            children: [
              _menuBtn('Salva', () => _showInputDialog(false)),
              const SizedBox(height: 8),
              _menuBtn('Condividi', () => _showInputDialog(true)),
            ],
          ),
        ),
    ],
  );

  Widget _botMsg(String t) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CircleAvatar(
        backgroundImage: AssetImage(widget.characterImage),
        radius: 20,
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FB),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.play_arrow, size: 20),
                  onPressed: () => _speak(t),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _userMsg(String t) => Align(
    alignment: Alignment.centerRight,
    child: Container(
      margin: const EdgeInsets.only(bottom: 12, left: 60),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(t, style: const TextStyle(color: Colors.white)),
          IconButton(
            icon: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
            onPressed: () => _speak(t),
          ),
        ],
      ),
    ),
  );

  Widget _inputArea() {
    if (widget.isReadOnly) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.mic, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Scrivi qui...',
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuBtn(String l, VoidCallback f) => SizedBox(
    width: 110,
    child: ElevatedButton(
      onPressed: f,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(l, style: const TextStyle(color: Colors.white)),
      ),
    ),
  );
}

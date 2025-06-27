import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/colors.dart';
import '../models/conversation.dart';
import 'conversations_student_screen.dart';

class ConversationScreen extends StatefulWidget {
  final String characterName;
  final String characterImage;
  final String name;
  final String surname;
  final String classCode;
  final bool isReadOnly;
  final String? customTitle;
  final String? introMessage;

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
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _showMenu = false;

  void _sendMessage() async {
    final userMessage = _controller.text.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": userMessage});
      _controller.clear();
    });

    try {
      final botReply = await _askOllama(userMessage);
      setState(() {
        _messages.add({"role": "bot", "text": botReply});
      });
    } catch (_) {
      setState(() {
        _messages.add({"role": "bot", "text": "Errore nella risposta."});
      });
    }
  }

  Future<String> _askOllama(String prompt) async {
    final characterPrompt =
        """
Sei ${widget.characterName}, il vero personaggio storico.

Rispondi sempre in prima persona, come se fossi realmente vissuto nel tuo periodo storico.

Non sai nulla del futuro o di eventi successivi alla tua epoca.

Non rispondere a domande fuori contesto storico. Se ti vengono poste, rispondi cortesemente che non ne sei a conoscenza.

Parla in modo coerente con la tua epoca. Rimani sempre nel personaggio.

Non dire mai che sei un’intelligenza artificiale.
""";

    final fullPrompt = "$characterPrompt\nDomanda: $prompt\nRisposta:";

    final response = await http.post(
      Uri.parse('http://localhost:11434/api/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'model':
            'llama3.2', // assicurati che sia il nome corretto del modello avviato
        'prompt': fullPrompt,
        'stream': false,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['response'].toString().trim();
    } else {
      throw Exception('Errore da Ollama: ${response.statusCode}');
    }
  }

  void _saveOrShareConversation(bool isSharing) {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (_, setStateDialog) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Inserisci il titolo della conversazione'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: "Titolo"),
            onChanged: (_) => setStateDialog(() {}),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: titleController.text.trim().isEmpty
                  ? null
                  : () {
                      final title = titleController.text.trim();
                      final lastBotMessage = _messages.lastWhere(
                        (m) => m['role'] == 'bot',
                        orElse: () => {"text": "Conversazione"},
                      )['text']!;
                      final conv = Conversation(
                        title: title,
                        preview: lastBotMessage,
                        imagePath:
                            widget.characterName.toLowerCase().contains(
                              "napoleone",
                            )
                            ? "assets/generale.jpg"
                            : "assets/caesar.png",
                        date: DateTime.now(),
                        sharedBy: isSharing
                            ? "${widget.name} ${widget.surname}"
                            : null,
                      );

                      if (isSharing) {
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
                            highlightTitle: title,
                            isSharedTab: isSharing,
                          ),
                        ),
                      );
                    },
              child: Text(isSharing ? 'Condividi' : 'Salva'),
            ),
          ],
        ),
      ),
    );
  }

  String getIntroMessage() {
    return widget.introMessage ??
        (widget.characterName.toLowerCase().contains("napoleone")
            ? "Sono Napoleone Bonaparte, imperatore dei francesi. Chiedimi pure."
            : "Io sono Giulio Cesare, console di Roma. Cosa desideri sapere?");
  }

  @override
  void initState() {
    super.initState();
    _messages.add({"role": "bot", "text": getIntroMessage()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        centerTitle: true,
        title: Text(
          widget.customTitle ?? widget.characterName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (!widget.isReadOnly)
            IconButton(
              icon: Icon(
                _showMenu ? Icons.close : Icons.menu,
                color: Colors.black,
              ),
              onPressed: () => setState(() => _showMenu = !_showMenu),
            ),
        ],
      ),
      body: Stack(
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
                    final msg = _messages[i];
                    return msg['role'] == 'user'
                        ? _buildUserMessage(msg['text']!)
                        : _buildCharacterMessage(msg['text']!);
                  },
                ),
              ),
              if (!widget.isReadOnly) _buildInputArea(),
            ],
          ),
          if (_showMenu && !widget.isReadOnly)
            Positioned(
              top: 12,
              right: 12,
              child: Column(
                children: [
                  _buildMenuButton(
                    "Salva",
                    () => _saveOrShareConversation(false),
                  ),
                  const SizedBox(height: 8),
                  _buildMenuButton(
                    "Condividi",
                    () => _saveOrShareConversation(true),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCharacterMessage(String text) => Row(
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
          child: Text(text),
        ),
      ),
    ],
  );

  Widget _buildUserMessage(String text) => Align(
    alignment: Alignment.centerRight,
    child: Container(
      margin: const EdgeInsets.only(bottom: 12, left: 60),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    ),
  );

  Widget _buildInputArea() => Container(
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
              hintText: "Scrivi qui...",
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

  Widget _buildMenuButton(String label, VoidCallback onTap) => SizedBox(
    width: 100,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    ),
  );
}

import 'package:flutter/material.dart';
import '../models/domanda_model.dart';
import '../constants/colors.dart';

class SchermataConversazione extends StatefulWidget {
  final DomandaModel domanda;
  final Function(DomandaModel) onRispostaInviata;

  const SchermataConversazione({
    super.key,
    required this.domanda,
    required this.onRispostaInviata,
  });

  @override
  State<SchermataConversazione> createState() => _SchermataConversazioneState();
}

class _SchermataConversazioneState extends State<SchermataConversazione> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> messaggiUtente = [];
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.domanda.stato == StatoDomanda.nuova) {
        widget.domanda.stato = StatoDomanda.incompleta;
        widget.onRispostaInviata(widget.domanda);
      }
      _textController.text = widget.domanda.testo;
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    widget.domanda.immagineAsset,
                    width: 300,
                    height: 400,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Expanded(flex: 3, child: _buildMessagesArea()),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (_) => Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Attenzione !',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Se esci senza salvare, perderai la conversazione',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(false),
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
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDF1818),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Torna indietro',
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
        ) ??
        false;
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () async {
          if (await _onWillPop()) {
            Navigator.pop(context);
          }
        },
      ),
      title: Text(
        widget.domanda.personaggio,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMessagesArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: messaggiUtente.isEmpty
          ? const SizedBox.shrink()
          : ListView.builder(
              itemCount: messaggiUtente.length,
              itemBuilder: (context, index) {
                return _buildUserMessage(messaggiUtente[index]);
              },
            ),
    );
  }

  Widget _buildUserMessage(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8, left: 50),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          message,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _toggleRecording,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isRecording ? Colors.red : const Color(0xFF29B6F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                isRecording ? Icons.stop : Icons.mic,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _textController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Scrivi la tua risposta...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (text) => _inviaMessaggio(text),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => _inviaMessaggio(_textController.text),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF29B6F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleRecording() {
    setState(() {
      isRecording = !isRecording;
    });

    if (!isRecording) {
      _inviaMessaggioVocale();
    }
  }

  void _inviaMessaggioVocale() {
    _inviaMessaggio("Messaggio vocale trascritto");
  }

  void _inviaMessaggio(String testo) {
    if (testo.trim().isEmpty) return;

    setState(() {
      messaggiUtente.add(testo.trim());
      _textController.clear();

      if (widget.domanda.stato != StatoDomanda.completa) {
        widget.domanda.stato = StatoDomanda.completa;
        widget.onRispostaInviata(widget.domanda);
      }
    });
  }
}

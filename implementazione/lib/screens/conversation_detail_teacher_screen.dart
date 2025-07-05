import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../constants/colors.dart';
import 'home_teacher_screen.dart';
import 'conversazioni_screen.dart';
import 'settings_teacher_screen.dart';

class ConversationDetailTeacherScreen extends StatefulWidget {
  final String sharedBy;
  final String characterName;
  final String characterImage;
  final List<Map<String, String>> messages;
  final String teacherName;
  final String teacherSurname;

  const ConversationDetailTeacherScreen({
    super.key,
    required this.sharedBy,
    required this.characterName,
    required this.characterImage,
    required this.messages,
    required this.teacherName,
    required this.teacherSurname,
  });

  @override
  State<ConversationDetailTeacherScreen> createState() =>
      _ConversationDetailTeacherScreenState();
}

class _ConversationDetailTeacherScreenState
    extends State<ConversationDetailTeacherScreen> {
  final FlutterTts _tts = FlutterTts();

  Future<void> _speak(String text) async {
    await _tts.setLanguage("it-IT");
    await _tts.setPitch(1.0);
    await _tts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              widget.sharedBy,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              "Conversazione con ${widget.characterName}",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(widget.characterImage, height: 160),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: widget.messages.length,
              itemBuilder: (_, i) {
                final msg = widget.messages[i];
                final sender = msg['sender'] ?? '';
                final text = msg['text'] ?? '';
                final isUser = sender.toLowerCase().contains('studente');

                return isUser
                    ? _buildUserMessage(text)
                    : _buildCharacterMessage(text);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // valore valido, ma tutti i colori sono grigi
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(color: Colors.grey),
        unselectedLabelStyle: const TextStyle(color: Colors.grey),
        backgroundColor: Colors.white,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeTeacherScreen(
                    name: widget.teacherName,
                    surname: widget.teacherSurname,
                  ),
                ),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ConversazioniScreen(
                    name: widget.teacherName,
                    surname: widget.teacherSurname,
                  ),
                ),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsTeacherScreen(
                    name: widget.teacherName,
                    surname: widget.teacherSurname,
                  ),
                ),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Conversazioni',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Impostazioni',
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FB),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(child: Text(text)),
              IconButton(
                icon: const Icon(Icons.play_arrow, size: 20),
                onPressed: () => _speak(text),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _buildUserMessage(String text) => Align(
    alignment: Alignment.centerRight,
    child: Container(
      margin: const EdgeInsets.only(bottom: 12, left: 60),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
            onPressed: () => _speak(text),
          ),
        ],
      ),
    ),
  );
}

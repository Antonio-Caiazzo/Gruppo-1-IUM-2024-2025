import 'package:flutter/material.dart';
import '../models/conversation.dart';
import '../screens/conversation_period_selection_screen.dart';
import '../widgets/student_bottom_nav_bar.dart';

class SharedConversationsScreen extends StatelessWidget {
  final String name;
  final String surname;
  final String classCode;
  final String? highlightTitle;

  const SharedConversationsScreen({
    super.key,
    required this.name,
    required this.surname,
    required this.classCode,
    this.highlightTitle,
  });

  @override
  Widget build(BuildContext context) {
    final List<Conversation> conversations = [
      Conversation(
        title: "Giulio Cesare",
        preview: "Ho reso Roma una potenza...",
        imagePath: "assets/cesare.png",
        date: DateTime(2025, 4, 17, 16, 40),
      ),
      Conversation(
        title: "Il Foro",
        preview: "Ho reso Roma una potenza...",
        imagePath: "assets/cesare.png",
        date: DateTime(2025, 4, 17, 16, 40),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversazioni"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conv = conversations[index];
          final isHighlighted = conv.title == highlightTitle;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: isHighlighted
                  ? Colors.lightGreenAccent.withOpacity(0.3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(conv.imagePath),
              ),
              title: Text(conv.title),
              subtitle: Text(conv.preview),
              trailing: Text(
                "${conv.date.day.toString().padLeft(2, '0')}/${conv.date.month.toString().padLeft(2, '0')}/${conv.date.year} ${conv.date.hour.toString().padLeft(2, '0')}:${conv.date.minute.toString().padLeft(2, '0')}",
              ),
              onTap: () {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ConversationPeriodSelectionScreen(
                name: name,
                surname: surname,
                classCode: classCode,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: StudentBottomNavigationBar(
        currentIndex: 1,
        name: name,
        surname: surname,
        classCode: classCode,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/conversation.dart';
import 'conversation_screen.dart';
import 'conversation_period_selection_screen.dart';
import '../widgets/student_bottom_nav_bar.dart';

class ConversationsStudentScreen extends StatefulWidget {
  final String name;
  final String surname;
  final String classCode;
  final String? highlightTitle;
  final bool isSharedTab;

  const ConversationsStudentScreen({
    super.key,
    required this.name,
    required this.surname,
    required this.classCode,
    this.highlightTitle,
    this.isSharedTab = false,
  });

  @override
  State<ConversationsStudentScreen> createState() =>
      _ConversationsStudentScreenState();
}

class _ConversationsStudentScreenState extends State<ConversationsStudentScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String? _highlightTitle;

  @override
  void initState() {
    super.initState();
    _highlightTitle = widget.highlightTitle;

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.isSharedTab ? 1 : 0,
    );

    if (_highlightTitle != null) {
      Future.delayed(const Duration(seconds: 3), () {
        setState(() => _highlightTitle = null);
      });
    }
  }

  Widget buildConversationList(
    List<Conversation> conversations,
    bool isShared,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: conversations.length,
      itemBuilder: (_, index) {
        final conv = conversations[index];
        final isHighlighted = conv.title == _highlightTitle;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isHighlighted ? const Color(0xFFCCF0FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(conv.imagePath),
              radius: 24,
            ),
            title: Text(
              conv.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              isShared && conv.sharedBy != null
                  ? "Condivisa da ${conv.sharedBy}"
                  : conv.preview,
            ),
            trailing: Text(
              "${conv.date.day.toString().padLeft(2, '0')}/${conv.date.month.toString().padLeft(2, '0')}/${conv.date.year}",
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ConversationScreen(
                    characterName: conv.title,
                    characterImage: conv.imagePath,
                    name: widget.name,
                    surname: widget.surname,
                    classCode: widget.classCode,
                    isReadOnly: true,
                    customTitle: conv.title,
                    introMessage: conv.preview,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final saved = ConversationScreen.saved;
    final shared = [
      ...ConversationScreen.shared,
      Conversation(
        title: "Condivisa 1",
        preview: "Conversazione storica.",
        imagePath: "assets/generale.jpg",
        date: DateTime(2025, 6, 1),
        sharedBy: "Elena Bianchi",
      ),
      Conversation(
        title: "Condivisa 2",
        preview: "Scoperta interessante.",
        imagePath: "assets/caesar.png",
        date: DateTime(2025, 6, 2),
        sharedBy: "Riccardo Gialli",
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Conversazioni",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "Salvate"),
            Tab(text: "Condivise"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildConversationList(saved, false),
          buildConversationList(shared, true),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ConversationPeriodSelectionScreen(
                name: widget.name,
                surname: widget.surname,
                classCode: widget.classCode,
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: StudentBottomNavigationBar(
        currentIndex: 1,
        name: widget.name,
        surname: widget.surname,
        classCode: widget.classCode,
      ),
    );
  }
}

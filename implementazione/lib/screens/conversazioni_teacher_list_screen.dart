import 'package:flutter/material.dart';
import 'package:historia/screens/home_teacher_screen.dart';
import '../models/conversation.dart';
import '../constants/colors.dart';
import 'conversation_detail_teacher_screen.dart';
import '../widgets/teacher_bottom_nav_bar.dart';

class ConversazioniTeacherListScreen extends StatefulWidget {
  final String className;
  final String name;
  final String surname;

  const ConversazioniTeacherListScreen({
    super.key,
    required this.className,
    required this.name,
    required this.surname,
  });

  @override
  State<ConversazioniTeacherListScreen> createState() =>
      _ConversazioniTeacherListScreenState();
}

class _ConversazioniTeacherListScreenState
    extends State<ConversazioniTeacherListScreen> {
  List<String> selectedPeriods = [];
  String searchQuery = '';

  final List<Conversation> allConversations = [
    Conversation(
      title: "Incontro con Giulio Cesare",
      imagePath: 'assets/caesar.png',
      preview: "Una conversazione intensa sull'antica Roma...",
      date: DateTime(2025, 7, 4),
      sharedBy: 'Luca Bianchi',
      period: 'Impero Romano',
      messages: [
        {'sender': 'Cesare', 'text': 'Veni, vidi, vici.'},
        {'sender': 'Studente', 'text': 'Cosa significa?'},
      ],
    ),
    Conversation(
      title: "Dialogo con Napoleone",
      imagePath: 'assets/generale.jpg',
      preview: "Napoleone racconta le sue battaglie più celebri...",
      date: DateTime(2025, 7, 3),
      sharedBy: 'Giulia Verdi',
      period: 'Rivoluzione Francese',
      messages: [
        {'sender': 'Napoleone', 'text': 'La mia strategia era semplice.'},
        {'sender': 'Studente', 'text': 'Hai mai avuto paura?'},
      ],
    ),
    Conversation(
      title: "Cesare parla ai posteri",
      imagePath: 'assets/caesar.png',
      preview: "Un'intervista virtuale esclusiva con Cesare...",
      date: DateTime(2025, 7, 2),
      sharedBy: 'Marco Neri',
      period: 'Impero Romano',
      messages: [
        {'sender': 'Studente', 'text': 'Come sei diventato imperatore?'},
        {'sender': 'Cesare', 'text': 'Con il consenso e la forza.'},
      ],
    ),
  ];

  List<Conversation> get filteredConversations {
    return allConversations.where((conv) {
      final matchesTitle = conv.title.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      final matchesPeriod =
          selectedPeriods.isEmpty || selectedPeriods.contains(conv.period);
      return matchesTitle && matchesPeriod;
    }).toList();
  }

  void _showFilterDialog() {
    List<String> tempSelected = List.from(selectedPeriods);

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setInnerState) => AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Filtra per periodo storico"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                activeColor: AppColors.primary,
                title: const Text("Impero Romano"),
                value: tempSelected.contains("Impero Romano"),
                onChanged: (val) => setInnerState(() {
                  val!
                      ? tempSelected.add("Impero Romano")
                      : tempSelected.remove("Impero Romano");
                }),
              ),
              CheckboxListTile(
                activeColor: AppColors.primary,
                title: const Text("Rivoluzione Francese"),
                value: tempSelected.contains("Rivoluzione Francese"),
                onChanged: (val) => setInnerState(() {
                  val!
                      ? tempSelected.add("Rivoluzione Francese")
                      : tempSelected.remove("Rivoluzione Francese");
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Annulla",
                style: TextStyle(color: AppColors.primary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: () {
                setState(() => selectedPeriods = tempSelected);
                Navigator.pop(context);
              },
              child: const Text(
                "Applica",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _extractCharacterName(String title) {
    if (title.toLowerCase().contains('cesare')) return 'Giulio Cesare';
    if (title.toLowerCase().contains('napoleone')) return 'Napoleone Bonaparte';
    return 'Personaggio storico';
  }

  Widget _buildConversationCard(Conversation conv) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        backgroundImage: AssetImage(conv.imagePath),
        radius: 28,
      ),
      title: Text(
        conv.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text("Condivisa da ${conv.sharedBy ?? 'Sconosciuto'}"),
      trailing: Text(
        "${conv.date.day.toString().padLeft(2, '0')}/${conv.date.month.toString().padLeft(2, '0')}/${conv.date.year}",
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ConversationDetailTeacherScreen(
              sharedBy: conv.sharedBy ?? '',
              characterName: _extractCharacterName(conv.title),
              characterImage: conv.imagePath,
              messages: conv.messages,
              teacherName: widget.name,
              teacherSurname: widget.surname,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Classe ${widget.className}"),
        centerTitle: true,
        backgroundColor: AppColors.background,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeTeacherScreen(
                  name: widget.name,
                  surname: widget.surname,
                ),
              ),
            );
          },
        ),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Cerca per titolo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _showFilterDialog,
                  icon: const Icon(Icons.filter_list),
                  label: const Text("Filtra"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredConversations.isEmpty
                ? const Center(child: Text("Nessuna conversazione trovata."))
                : ListView.builder(
                    itemCount: filteredConversations.length,
                    itemBuilder: (_, index) =>
                        _buildConversationCard(filteredConversations[index]),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: TeacherBottomNavigationBar(
        name: widget.name,
        surname: widget.surname,
        currentIndex: 1, // Conversazioni
      ),
    );
  }
}

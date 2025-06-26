import 'package:flutter/material.dart';
import '../widgets/teacher_bottom_nav_bar.dart';
import "domande_prof_screen.dart";

class ClassSelectorScreen extends StatelessWidget {
  final String name;
  final String surname;

  final List<Map<String, String>> classi = [
    {'name': 'I-A', 'year': '2025'},
    {'name': 'II-A', 'year': '2025'},
    {'name': 'III-A', 'year': '2025'},
    {'name': 'IV-A', 'year': '2025'},
    {'name': 'V-A', 'year': '2025'},
    {'name': 'I-B', 'year': '2025'},
    {'name': 'II-B', 'year': '2025'},
    {'name': 'III-B', 'year': '2025'},
    {'name': 'IV-B', 'year': '2025'},
    {'name': 'V-B', 'year': '2025'},
    {'name': 'I-C', 'year': '2025'},
    {'name': 'III-C', 'year': '2025'},
  ];

  ClassSelectorScreen({Key? key, required this.name, required this.surname})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Domande'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'Seleziona una classe per\nvisualizzare o assegnare le domande',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: classi.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final classe = classi[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            QuestionScreen(name: name, surname: surname),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.lightBlue[100],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 5,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            classe['name']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(classe['year']!),
                        ],
                      ),
                    ),
                  ),
                );
              },

            ),
          ),
        ],
      ),
      bottomNavigationBar: TeacherBottomNavigationBar(
        currentIndex: 0,
        name: name,
        surname: surname,
      ),
    );
  }
}

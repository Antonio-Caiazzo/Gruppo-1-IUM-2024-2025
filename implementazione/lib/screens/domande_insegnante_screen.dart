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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.0,
              ),
              itemCount: classi.length,
              itemBuilder: (context, index) {
                final classe = classi[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuestionScreen(
                          name: name,
                          surname: surname,
                          className: classe['name']!,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white, // Card background
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            Colors.grey.shade300, // Always a light grey border
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: const Color(
                            0x472CBDFB,
                          ), // Light blue background for the inner square
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              classe['name']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0277BD),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              classe['year']!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF0277BD),
                              ),
                            ),
                          ],
                        ),
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

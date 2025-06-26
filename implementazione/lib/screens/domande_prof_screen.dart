import 'package:flutter/material.dart';
import '../widgets/teacher_bottom_nav_bar.dart';

class QuestionScreen extends StatelessWidget {
  final String className = "III-B 2025";
  final String name;
  final String surname;

  QuestionScreen({required this.name, required this.surname});

  final List<Map<String, String>> questions = [
    {
      "text": "Come hanno costruito il Colosseo i romani?",
      "time": "17/04/2025 16:40",
    },
    {
      "text": "Come hanno costruito il Foro i romani?",
      "time": "17/04/2025 16:40",
    },
    {"text": "Dove è nato Giulio Cesare?", "time": "17/04/2025 16:40"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(className),
        backgroundColor: Colors.deepPurple[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barra di ricerca e bottone Aggiungi
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Cerca domanda",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Aggiungi"),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Elenco delle domande
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final q = questions[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    margin: EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            q["text"]!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Aggiunta il ${q["time"]}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text("Modifica"),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text("Elimina"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation personalizzata
      bottomNavigationBar: TeacherBottomNavigationBar(
        currentIndex: 0,
        name: name,
        surname: surname,
      ),
    );
  }
}

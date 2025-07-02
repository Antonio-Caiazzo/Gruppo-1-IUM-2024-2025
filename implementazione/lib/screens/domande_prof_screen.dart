import 'package:flutter/material.dart';
import '../widgets/teacher_bottom_nav_bar.dart';
import 'aggiungi_domanda_screen.dart';
import '../data/question_storage_data.dart';

class QuestionScreen extends StatefulWidget {
  final String className;
  final String name;
  final String surname;

  QuestionScreen({
    required this.className,
    required this.name,
    required this.surname,
  });

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int selectedIndex = -1;

  late List<Map<String, String>> questions;

  @override
  void initState() {
    super.initState();
    // Carica le domande specifiche per la classe selezionata
    questions = List.from(
      QuestionStorage.getQuestionsForClass(widget.className),
    );
  }

  List<String> selectedPeriods = []; // ← per il filtro attivo

  void _navigateToAddQuestionScreen() async {
    final newQuestion = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddQuestionScreen()),
    );
    if (newQuestion != null && newQuestion is Map<String, String>) {
      setState(() {
        questions.add(newQuestion);
        selectedIndex = questions.length - 1;
        QuestionStorage.updateQuestionsForClass(widget.className, questions);
      });
    }
  }

  void _showDeleteConfirmationDialog(Map<String, String> question) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Attenzione !',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text('Confermare l\'eliminazione?', textAlign: TextAlign.center),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        questions.removeWhere(
                          (q) => q['text'] == question['text'],
                        );
                        QuestionStorage.updateQuestionsForClass(
                          widget.className,
                          questions,
                        );
                      });
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF5555),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Elimina",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2CBDFB),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      "Annulla",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.className,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cerca domanda",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                ElevatedButton(
                  onPressed: _navigateToAddQuestionScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2CBDFB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Aggiungi",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Domanda',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
            SizedBox(height: 10), // spazio tra input e pulsante nuovo
            ElevatedButton(
              onPressed: _showFilterDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2CBDFB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("Filtra", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20), // spazio tra pulsante e lista

            Expanded(
              child: Builder(
                builder: (context) {
                  final filteredQuestions = questions
                      .where(
                        (q) =>
                            selectedPeriods.isEmpty ||
                            selectedPeriods.contains(q['period']),
                      )
                      .toList();

                  if (filteredQuestions.isEmpty && selectedPeriods.isNotEmpty) {
                    // Nessuna domanda trovata con il filtro attivo
                    return Center(
                      child: Text(
                        'Non sono presenti domande per il periodo storico: ${selectedPeriods.join(", ")}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredQuestions.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: _questionCard(
                          filteredQuestions[index]['text']!,
                          isSelected: selectedIndex == index,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: TeacherBottomNavigationBar(
        currentIndex: 0,
        name: widget.name,
        surname: widget.surname,
      ),
    );
  }

  Widget _questionCard(String question, {bool isSelected = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF2CBDFB), width: isSelected ? 4 : 2),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "17/04/2025 16:40",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2CBDFB),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                    child: Text(
                      "Modifica",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _showDeleteConfirmationDialog({
                      "text": question,
                      "period":
                          "", // Puoi passare il periodo corretto se disponibile
                    }),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF5555),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      textStyle: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    child: Text(
                      "Elimina",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    List<String> tempSelected = List.from(selectedPeriods);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setInnerState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text("Filtra per periodo"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: Text("Impero Romano"),
                    value: tempSelected.contains("Impero Romano"),
                    onChanged: (bool? value) {
                      setInnerState(() {
                        value!
                            ? tempSelected.add("Impero Romano")
                            : tempSelected.remove("Impero Romano");
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text("Rivoluzione Francese"),
                    value: tempSelected.contains("Rivoluzione Francese"),
                    onChanged: (bool? value) {
                      setInnerState(() {
                        value!
                            ? tempSelected.add("Rivoluzione Francese")
                            : tempSelected.remove("Rivoluzione Francese");
                      });
                    },
                  ),
                ],
              ),
              actionsPadding: EdgeInsets.only(
                bottom: 12,
              ), // aggiunto padding inferiore
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedPeriods = []; // azzera i filtri
                        });
                        Navigator.of(context).pop(); // chiudi il dialog
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF5555),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: Text(
                        "Annulla filtro",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(tempSelected);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2CBDFB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                      ),
                      child: Text(
                        "Applica",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    ).then((selected) {
      if (selected != null && selected is List<String>) {
        setState(() {
          selectedPeriods = selected;
        });
      }
    });
  }
}

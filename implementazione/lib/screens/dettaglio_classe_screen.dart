import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../widgets/teacher_bottom_nav_bar.dart';

class DettaglioClasseScreen extends StatefulWidget {
  final String name;
  final String surname;
  final Map<String, dynamic> classe;
  final int classeIndex;

  const DettaglioClasseScreen({
    super.key,
    required this.name,
    required this.surname,
    required this.classe,
    required this.classeIndex,
  });

  @override
  _DettaglioClasseScreenState createState() => _DettaglioClasseScreenState();
}

class _DettaglioClasseScreenState extends State<DettaglioClasseScreen> {
  late Map<String, dynamic> classeCorrente;
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _annoController = TextEditingController();

  final List<String> _defaultStudentsForNewClasses = [
    'Bianchi Luigi',
    'Rossi Mario',
    'Verdi Luca',
  ];

  @override
  void initState() {
    super.initState();
    classeCorrente = Map<String, dynamic>.from(widget.classe);

    _nomeController.text = classeCorrente['nome']!;
    _annoController.text = classeCorrente['anno']!;

    if (classeCorrente['studenti'] == null || (classeCorrente['studenti'] as List).isEmpty) {
      classeCorrente['studenti'] = List<String>.from(_defaultStudentsForNewClasses);
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _annoController.dispose();
    super.dispose();
  }

  String get codiceClasse => '${classeCorrente['nome']}${classeCorrente['anno']}';

  void _showSnackBar(
      String message, {
        Color backgroundColor = Colors.black,
        Color textColor = Colors.white,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
    );
  }

  Future<void> _salvaModifiche() async {
    final prefs = await SharedPreferences.getInstance();
    final savedClassi = prefs.getString('classiList');

    if (savedClassi != null) {
      List<Map<String, dynamic>> classi = List<Map<String, dynamic>>.from(
        (json.decode(savedClassi) as List).map(
              (e) => Map<String, dynamic>.from(e)..putIfAbsent('studenti', () => []),
        ),
      );

      classi[widget.classeIndex] = classeCorrente;
      await prefs.setString('classiList', json.encode(classi));

      _showSnackBar(
        'Classe "${classeCorrente['nome']}" modificata con successo!',
        backgroundColor: Colors.green.shade700,
      );
    }
  }

  Future<void> _confermaEliminazione() async {
    final String classNameToDelete = classeCorrente['nome']!;

    final bool? conferma = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Attenzione', textAlign: TextAlign.center),
        content: const Text('Confermare l\'eliminazione?', textAlign: TextAlign.center),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5555),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              elevation: 0,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Elimina', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2CBDFB),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              elevation: 0,
            ),
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );

    if (conferma == true) {
      await _eliminaClasse();
      _showSnackBar(
        'Classe "$classNameToDelete" eliminata con successo!',
        backgroundColor: Colors.red.shade700,
      );
      Navigator.pop(context);
    }
  }

  Future<void> _eliminaClasse() async {
    final prefs = await SharedPreferences.getInstance();
    final savedClassi = prefs.getString('classiList');

    if (savedClassi != null) {
      List<Map<String, dynamic>> classi = List<Map<String, dynamic>>.from(
        (json.decode(savedClassi) as List).map(
              (e) => Map<String, dynamic>.from(e),
        ),
      );

      classi.removeAt(widget.classeIndex);
      await prefs.setString('classiList', json.encode(classi));
    }
  }

  void _mostraDialogModifica() {
    // Creiamo una copia della lista degli studenti
    List<String> tempStudentNames = List<String>.from(classeCorrente['studenti'] as List<dynamic>);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: const Text('Modifica Classe', textAlign: TextAlign.center),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome Classe',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setStateDialog(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _annoController,
                      decoration: InputDecoration(
                        labelText: 'Anno (parte del codice)',
                        border: const OutlineInputBorder(),
                        helperText: 'Codice Classe: ${_nomeController.text}${_annoController.text}',
                      ),
                      onChanged: (value) {
                        setStateDialog(() {});
                      },
                    ),
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Studenti:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Lista studenti dinamica - usando chiavi univoche e gestione semplificata
                    if (tempStudentNames.isNotEmpty)
                      ...List.generate(tempStudentNames.length, (index) {
                        return Padding(
                          key: ValueKey('student_$index'),
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  key: ValueKey('textfield_$index'),
                                  initialValue: tempStudentNames[index],
                                  decoration: InputDecoration(
                                    labelText: 'Studente ${index + 1}',
                                    border: const OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    tempStudentNames[index] = value.trim();
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.delete_forever, color: Colors.red),
                                onPressed: () {
                                  setStateDialog(() {
                                    tempStudentNames.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      })
                    else
                      const Text(
                        'Nessuno studente in questa classe.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),

                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2CBDFB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_nomeController.text.trim().isNotEmpty && _annoController.text.trim().isNotEmpty) {
                      // Filtra gli studenti vuoti
                      final List<String> finalStudentNames = tempStudentNames.where((name) => name.isNotEmpty).toList();

                      setState(() {
                        classeCorrente['nome'] = _nomeController.text.trim();
                        classeCorrente['anno'] = _annoController.text.trim();
                        classeCorrente['studenti'] = finalStudentNames;
                      });

                      _salvaModifiche();
                      Navigator.pop(context);
                    } else {
                      _showSnackBar('Nome e Anno della classe non possono essere vuoti!', backgroundColor: Colors.orange.shade700);
                    }
                  },
                  child: const Text('Conferma', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5555),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Ripristina i valori originali
                    _nomeController.text = widget.classe['nome']!;
                    _annoController.text = widget.classe['anno']!;
                    Navigator.pop(context);
                  },
                  child: const Text('Annulla', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> studentsToDisplay = (classeCorrente['studenti'] as List<dynamic>?)
        ?.map((s) => s.toString())
        .toList() ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                classeCorrente['nome']!,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Codice: ',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: codiceClasse,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF2CBDFB),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              if (studentsToDisplay.isNotEmpty)
                ...studentsToDisplay.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      '${entry.key + 1}. ${entry.value}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }).toList()
              else
                const Text(
                  'Nessuno studente in questa classe.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 30),
              // Bottoni spostati qui, sotto l'elenco degli studenti
              Column(
                children: [
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2CBDFB),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        elevation: 0,
                      ),
                      onPressed: _mostraDialogModifica,
                      child: const Text(
                        'Modifica',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5555),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        elevation: 0,
                      ),
                      onPressed: _confermaEliminazione,
                      child: const Text(
                        'Elimina',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: TeacherBottomNavigationBar(
        currentIndex: 0,
        name: widget.name,
        surname: widget.surname,
      ),
    );
  }
}
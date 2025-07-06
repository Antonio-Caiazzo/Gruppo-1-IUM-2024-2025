import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../widgets/teacher_bottom_nav_bar.dart';
import 'aggiungi_classe_screen.dart';
import 'dettaglio_classe_screen.dart';

class ClassiScreen extends StatefulWidget {
  final String name;
  final String surname;

  const ClassiScreen({super.key, required this.name, required this.surname});

  @override
  _ClassiScreenState createState() => _ClassiScreenState();
}

class _ClassiScreenState extends State<ClassiScreen> {
  List<Map<String, dynamic>> classi = []; // Changed to dynamic for students list
  int? selectedIndex;
  bool isDeleteMode = false;

  final List<Map<String, dynamic>> defaultClassi = [
    {'nome': 'I - A', 'anno': '2025', 'studenti': ['Bianchi Luigi', 'Rossi Mario', 'Verdi Luca']},
    {'nome': 'II - A', 'anno': '2025', 'studenti': []}, // Example with empty students
    {'nome': 'III - A', 'anno': '2025', 'studenti': ['Gialli Anna']},
    {'nome': 'IV - A', 'anno': '2025', 'studenti': []},
    {'nome': 'V - A', 'anno': '2025', 'studenti': []},
    {'nome': 'I - B', 'anno': '2025', 'studenti': []},
    {'nome': 'II - B', 'anno': '2025', 'studenti': []},
    {'nome': 'III - B', 'anno': '2025', 'studenti': []},
    {'nome': 'IV - B', 'anno': '2025', 'studenti': []},
    {'nome': 'V - B', 'anno': '2025', 'studenti': []},
    {'nome': 'I - C', 'anno': '2025', 'studenti': []},
    {'nome': 'III - C', 'anno': '2025', 'studenti': []},
  ];

  @override
  void initState() {
    super.initState();
    _loadClassi();
  }

  Future<void> _loadClassi() async {
    final prefs = await SharedPreferences.getInstance();
    final savedClassi = prefs.getString('classiList');
    if (savedClassi != null) {
      setState(() {
        classi = List<Map<String, dynamic>>.from(
          (json.decode(savedClassi) as List).map(
            // Ensure student lists are also correctly deserialized
                (e) => Map<String, dynamic>.from(e)..putIfAbsent('studenti', () => []),
          ),
        );
      });
    } else {
      setState(() {
        classi = defaultClassi;
      });
      await _saveClassi();
    }
  }

  Future<void> _saveClassi() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('classiList', json.encode(classi));
  }

  // _aggiungiClasse is no longer directly called for adding, but useful if needed elsewhere
  void _aggiungiClasse(Map<String, String> nuovaClasse) async {
    setState(() {
      classi.add({
        'nome': nuovaClasse['nome']!,
        'anno': nuovaClasse['anno']!,
        'studenti': [], // New classes start with empty student list by default
      });
    });
    await _saveClassi();
  }

  void _toggleDeleteMode() {
    setState(() {
      isDeleteMode = !isDeleteMode;
      selectedIndex = null;
    });
  }

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
    );
  }

  void _confermaEliminazione() async {
    if (selectedIndex == null) return;

    final String classNameToDelete = classi[selectedIndex!]['nome']!;

    final bool? conferma = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Attenzione', textAlign: TextAlign.center),
        content: const Text(
          'Confermare l\'eliminazione?',
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5555),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Elimina',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2CBDFB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 0,
            ),
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Annulla',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (conferma == true) {
      setState(() {
        classi.removeAt(selectedIndex!);
        selectedIndex = null;
        isDeleteMode = false;
      });
      await _saveClassi();
      _showSnackBar(
        'Classe "$classNameToDelete" eliminata con successo!',
        backgroundColor: Colors.red.shade700,
      );
    }
  }

  // *** MODIFICA QUI per il ricaricamento dopo l'aggiunta ***
  Future<void> _navigateAndRefresh() async {
    final nuovaClasse = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            AggiungiClasseScreen(name: widget.name, surname: widget.surname),
      ),
    );
    // Indipendentemente dal fatto che una nuova classe sia stata aggiunta o meno,
    // ricarica sempre le classi per riflettere lo stato attuale.
    await _loadClassi();

    if (nuovaClasse != null) {
      _showSnackBar(
        'Classe "${nuovaClasse['nome']}" aggiunta con successo!',
        backgroundColor: Colors.green.shade700,
      );
    }
  }

  // Questa funzione è già corretta per il ricaricamento
  Future<void> _navigateToClasseDettaglio(int index) async {
    await Navigator.push( // Non abbiamo bisogno del risultato specifico true/false qui, basta che ritorni
      context,
      MaterialPageRoute(
        builder: (_) => DettaglioClasseScreen(
          name: widget.name,
          surname: widget.surname,
          classe: classi[index],
          classeIndex: index,
        ),
      ),
    );
    // Dopo essere tornati da DettaglioClasseScreen, ricarica sempre la lista
    // per riflettere eventuali modifiche (nome, anno, studenti) o eliminazioni.
    await _loadClassi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Classi',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              isDeleteMode
                  ? (selectedIndex != null
                  ? 'Classe "${classi[selectedIndex!]['nome']}" selezionata'
                  : 'Seleziona la classe da eliminare')
                  : 'Seleziona una classe per\nvisualizzare il codice e gli alunni',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isDeleteMode ? 20 : 16,
                color: Colors.black,
                fontWeight: isDeleteMode ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5555),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                    fixedSize: const Size(117, 51),
                  ),
                  onPressed: () {
                    if (isDeleteMode) {
                      if (selectedIndex != null) {
                        _confermaEliminazione();
                      }
                    } else {
                      _toggleDeleteMode();
                    }
                  },
                  child: Text(
                    isDeleteMode ? 'Conferma' : 'Elimina',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2CBDFB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                    fixedSize: const Size(126, 51),
                  ),
                  onPressed: () {
                    if (isDeleteMode) {
                      _toggleDeleteMode();
                    } else {
                      _navigateAndRefresh();
                    }
                  },
                  child: Text(
                    isDeleteMode ? 'Annulla' : 'Aggiungi',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
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
                final bool isCurrentlySelected = selectedIndex == index;

                return GestureDetector(
                  onTap: () {
                    if (isDeleteMode) {
                      setState(() {
                        selectedIndex = isCurrentlySelected ? null : index;
                      });
                    } else {
                      _navigateToClasseDettaglio(index);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCurrentlySelected
                            ? const Color(0xFF2CBDFB)
                            : Colors.grey.shade300,
                        width: isCurrentlySelected ? 4 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                        if (isCurrentlySelected)
                          BoxShadow(
                            color: const Color(0xFF2CBDFB).withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                      ],
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          color: isCurrentlySelected
                              ? const Color(0xFF2CBDFB).withOpacity(0.4)
                              : const Color(0x472CBDFB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              classe['nome']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isCurrentlySelected
                                    ? const Color(0xFF1565C0)
                                    : const Color(0xFF0277BD),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              classe['anno']!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isCurrentlySelected
                                    ? const Color(0xFF1565C0)
                                    : const Color(0xFF0277BD),
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
        name: widget.name,
        surname: widget.surname,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'aggiungi_classe_screen.dart';

class ClassiScreen extends StatefulWidget {
  const ClassiScreen({Key? key}) : super(key: key);

  @override
  _ClassiScreenState createState() => _ClassiScreenState();
}

class _ClassiScreenState extends State<ClassiScreen> {
  List<Map<String, String>> classi = [];
  int? selectedIndex;
  bool isDeleteMode = false; // Modalità eliminazione

  final List<Map<String, String>> defaultClassi = [
    {'nome': 'I - A', 'anno': '2025'},
    {'nome': 'II - A', 'anno': '2025'},
    {'nome': 'III - A', 'anno': '2025'},
    {'nome': 'IV - A', 'anno': '2025'},
    {'nome': 'V - A', 'anno': '2025'},
    {'nome': 'I - B', 'anno': '2025'},
    {'nome': 'II - B', 'anno': '2025'},
    {'nome': 'III - B', 'anno': '2025'},
    {'nome': 'IV - B', 'anno': '2025'},
    {'nome': 'V - B', 'anno': '2025'},
    {'nome': 'I - C', 'anno': '2025'},
    {'nome': 'III - C', 'anno': '2025'},
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
        classi = List<Map<String, String>>.from(
          (json.decode(savedClassi) as List).map(
            (e) => Map<String, String>.from(e),
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

  void _aggiungiClasse(Map<String, String> nuovaClasse) async {
    setState(() {
      classi.add(nuovaClasse);
    });
    await _saveClassi();
  }

  void _toggleDeleteMode() {
    setState(() {
      isDeleteMode = !isDeleteMode;
      selectedIndex = null;
    });
  }

  // Helper function to show a SnackBar
  void _showSnackBar(
    String message, {
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        duration: const Duration(
          seconds: 2,
        ), // How long the snackbar is visible
        behavior: SnackBarBehavior
            .floating, // Makes it float above the bottom navigation bar
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ), // Margin from edges
      ),
    );
  }

  void _confermaEliminazione() async {
    if (selectedIndex == null) return;

    final String classNameToDelete =
        classi[selectedIndex!]['nome']!; // Store name before deletion

    final bool? conferma = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Attenzione ', textAlign: TextAlign.center),
        content: const Text(
          'Confermare l\'eliminazione ?',
          textAlign: TextAlign.center,
        ),
        actions: [
          Container(
            height: 40,
            width: 100,
            child: ElevatedButton(
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
          ),
          const SizedBox(width: 8),
          Container(
            height: 40,
            width: 100,
            child: ElevatedButton(
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

  Future<void> _navigateAndRefresh() async {
    final nuovaClasse = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (_) => const AggiungiClasseScreen()),
    );
    if (nuovaClasse != null) {
      _aggiungiClasse(nuovaClasse);
      _showSnackBar(
        'Classe "${nuovaClasse['nome']}" aggiunta con successo!',
        backgroundColor: Colors.green.shade700,
      );
    }
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
                // Left Button: Elimina (normal mode) / Conferma (delete mode)
                Container(
                  height: 51,
                  width: 117,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDeleteMode
                          ? const Color(0xFFFF5555)
                          : const Color(0xFFFF5555),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
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
                ),
                // Right Button: Aggiungi (normal mode) / Annulla (delete mode)
                Container(
                  height: 51,
                  width: 117,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDeleteMode
                          ? const Color(0xFF2CBDFB)
                          : const Color(0xFF2CBDFB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 0,
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
                      setState(() {
                        selectedIndex = isCurrentlySelected ? null : index;
                      });
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 100,
                    height: 100,
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
                    ),
                    child: Container(
                      margin: isCurrentlySelected
                          ? const EdgeInsets.all(0)
                          : const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(11),
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: 0,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          onTap: (index) {
            switch (index) {
              case 0:
                break;
              case 1:
                Navigator.pushNamed(context, '/conversazioni');
                break;
              case 2:
                Navigator.pushNamed(context, '/impostazioni');
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline, size: 24),
              label: 'Conversazioni',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: 24),
              label: 'Impostazioni',
            ),
          ],
        ),
      ),
    );
  }
}

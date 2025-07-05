import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../widgets/teacher_bottom_nav_bar.dart';

class DettaglioClasseScreen extends StatefulWidget {
  final String name;
  final String surname;
  final Map<String, String> classe;
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
  late Map<String, String> classeCorrente;
  final TextEditingController _nomeController = TextEditingController();

  // Lista di esempio di 3 studenti
  final List<String> studenti = [
    'Bianchi Luigi',
    'Rossi Mario',
    'Verdi Luca',
  ];

  @override
  void initState() {
    super.initState();
    classeCorrente = Map<String, String>.from(widget.classe);
    _nomeController.text = classeCorrente['nome']!;
  }

  @override
  void dispose() {
    _nomeController.dispose();
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
      List<Map<String, String>> classi = List<Map<String, String>>.from(
        (json.decode(savedClassi) as List).map(
              (e) => Map<String, String>.from(e),
        ),
      );

      // Aggiorna la classe nell'elenco
      classi[widget.classeIndex] = classeCorrente;

      // Salva l'elenco aggiornato
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
      Navigator.pop(context, true); // Ritorna true per indicare che la classe è stata eliminata
    }
  }

  Future<void> _eliminaClasse() async {
    final prefs = await SharedPreferences.getInstance();
    final savedClassi = prefs.getString('classiList');

    if (savedClassi != null) {
      List<Map<String, String>> classi = List<Map<String, String>>.from(
        (json.decode(savedClassi) as List).map(
              (e) => Map<String, String>.from(e),
        ),
      );

      // Rimuovi la classe dall'elenco
      classi.removeAt(widget.classeIndex);

      // Salva l'elenco aggiornato
      await prefs.setString('classiList', json.encode(classi));
    }
  }

  void _mostraDialogModifica() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifica Classe', textAlign: TextAlign.center),
        content: TextField(
          controller: _nomeController,
          decoration: const InputDecoration(
            labelText: 'Nome Classe',
            border: OutlineInputBorder(),
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
              if (_nomeController.text.trim().isNotEmpty) {
                setState(() {
                  classeCorrente['nome'] = _nomeController.text.trim();
                });
                _salvaModifiche();
                Navigator.pop(context);
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
              _nomeController.text = classeCorrente['nome']!; // Ripristina il valore originale
              Navigator.pop(context);
            },
            child: const Text('Annulla', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 20), // spazio superiore più piccolo

              // Nome della classe
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

              // Codice della classe
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

              // Lista degli studenti
              Column(
                children: [
                  ...studenti.asMap().entries.map((entry) {
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
                  }),
                ],
              ),

              const SizedBox(height: 40),

              // Bottoni Modifica ed Elimina
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

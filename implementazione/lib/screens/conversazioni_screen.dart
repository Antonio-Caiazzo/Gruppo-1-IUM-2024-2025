import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../widgets/teacher_bottom_nav_bar.dart';

class ConversazioniScreen extends StatefulWidget {
  final String name;
  final String surname;

  const ConversazioniScreen({
    super.key,
    required this.name,
    required this.surname,
  });

  @override
  State<ConversazioniScreen> createState() => _ConversazioniScreenState();
}

class _ConversazioniScreenState extends State<ConversazioniScreen> {
  List<Map<String, String>> classi = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Conversazioni',
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
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Seleziona una classe',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(height: 10),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Hai selezionato la classe: ${classe['nome']}',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
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
                          color: const Color(0x472CBDFB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              classe['nome']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0277BD),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              classe['anno']!,
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
        currentIndex: 1,
        name: widget.name,
        surname: widget.surname,
      ),
    );
  }
}

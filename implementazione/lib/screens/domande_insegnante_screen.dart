import 'package:flutter/material.dart';

import '../widgets/teacher_bottom_nav_bar.dart';
import "domande_prof_screen.dart";

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Assuming this path is correct for your constants
// import '../constants/colors.dart';

class DomandeInsegnanteScreen extends StatefulWidget {
  const DomandeInsegnanteScreen({Key? key}) : super(key: key);

  @override
  _DomandeInsegnanteScreenState createState() => _DomandeInsegnanteScreenState();
}

class _DomandeInsegnanteScreenState extends State<DomandeInsegnanteScreen> {
  List<Map<String, String>> classi = [];

  // Default classes for initial load if no data is saved
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

  // Loads classes from SharedPreferences
  Future<void> _loadClassi() async {
    final prefs = await SharedPreferences.getInstance();
    final savedClassi = prefs.getString('classiList');
    if (savedClassi != null) {
      setState(() {
        classi = List<Map<String, String>>.from(
            (json.decode(savedClassi) as List).map((e) => Map<String, String>.from(e)));
      });
    } else {
      // If no saved classes, load default and save them
      setState(() {
        classi = defaultClassi;
      });
      await _saveClassi(); // Save default classes for future loads
    }
  }

  // Saves classes to SharedPreferences (useful if default classes are loaded for the first time)
  Future<void> _saveClassi() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('classiList', json.encode(classi));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white, // Assuming a white background
      appBar: AppBar(
        title: const Text('Domande Insegnante',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
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


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Assuming this path is correct for your constants
// import '../constants/colors.dart';

class ConversazioniScreen extends StatefulWidget {
  const ConversazioniScreen({Key? key}) : super(key: key);

  @override
  _ConversazioniScreenState createState() => _ConversazioniScreenState();
}

class _ConversazioniScreenState extends State<ConversazioniScreen> {
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
        title: const Text('Conversazioni',
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
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Seleziona una classe per avviare una conversazione',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(height: 10), // Reduced height as no buttons below
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
                // For ConversazioniScreen, we don't have a 'selectedIndex' for interactive selection
                // but we keep the visual consistency for the card itself.
                // We'll simulate a 'selected' state for the visual style, or remove it for simplicity.
                // For now, let's keep the card style consistent but without actual selection logic.
                // Or simply use a standard card without the selection highlights.
                // Let's use a standard card without the complex selection visual effects.

                return GestureDetector(
                  onTap: () {
                    // TODO: Implement navigation to chat screen for the selected class
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Hai selezionato la classe: ${classe['nome']}'),
                        duration: const Duration(seconds: 1),
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
                        color: Colors.grey.shade300, // Always a light grey border
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
                          color: const Color(0x472CBDFB), // Light blue background for the inner square
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Set to 1 for "Conversazioni"
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home'); // Navigate to Home, replacing current route
              break;
            case 1:
            // Conversazioni - already on this screen
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
    );
  }
}
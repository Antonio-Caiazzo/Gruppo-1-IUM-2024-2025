// lib/screens/quiz_selection_screen.dart
import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import 'quiz_intro_screen.dart';

class QuizSelectionScreen extends StatefulWidget {
  static const String routeName = '/quizSelection';

  const QuizSelectionScreen({Key? key}) : super(key: key);

  @override
  State<QuizSelectionScreen> createState() => _QuizSelectionScreenState();
}

class _QuizSelectionScreenState extends State<QuizSelectionScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
      // Se sei già sulla Home/Quiz Selection, non fare nulla di specifico per ora
        break;
      case 1:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conversazioni in arrivo')),
        );
        break;
      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impostazioni in arrivo')),
        );
        break;
    }
  }

  void _returnToQuizSelection() {
    Navigator.of(context).popUntil(ModalRoute.withName(QuizSelectionScreen.routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Bianco come da design
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Quiz',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Seleziona un periodo storico',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black87,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildQuizCard(
                    title: 'Impero Romano',
                    imagePath: 'assets/colosseum.png',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizIntroScreen(
                            quizTitle: 'Impero Romano', // Passa il titolo corretto
                            quizDescription: 'Inizia il quiz e dimostra la tua conoscenza sull\'Impero Romano.', // Passa la descrizione corretta
                            quizImage: 'assets/colosseum.png', // Passa l'immagine corretta
                            questions: romanEmpireQuestions,
                            onQuizCompleted: _returnToQuizSelection,
                            onQuizExited: _returnToQuizSelection,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildQuizCard(
                    title: 'Rivoluzione Francese',
                    imagePath: 'assets/rivoluzione.png', // Modificato a 'assets/napoleon.png' per coerenza con i design
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizIntroScreen(
                            quizTitle: 'Rivoluzione Francese', // Passa il titolo corretto
                            quizDescription: 'Metti alla prova le tue conoscenze sulla Rivoluzione Francese!', // Passa la descrizione corretta
                            quizImage: 'assets/rivoluzione.png', // Passa l'immagine corretta
                            questions: frenchRevolutionQuestions,
                            onQuizCompleted: _returnToQuizSelection,
                            onQuizExited: _returnToQuizSelection,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, size: 28),
            label: 'Conversazioni',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 28),
            label: 'Impostazioni',
          ),
        ],
      ),
    );
  }

  Widget _buildQuizCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        height: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain, // Modificato da .cover a .contain per adattarsi meglio al design
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(Icons.broken_image, size: 50, color: Colors.grey[400]),
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
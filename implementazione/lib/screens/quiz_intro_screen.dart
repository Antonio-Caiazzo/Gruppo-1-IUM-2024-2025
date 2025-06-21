// lib/screens/quiz_intro_screen.dart
import 'package:flutter/material.dart';
import '../models/quiz_models.dart';
import 'quiz_screen.dart';
import 'quiz_selection_screen.dart';

class QuizIntroScreen extends StatelessWidget {
  final String quizTitle;
  final String quizDescription;
  final String quizImage;
  final List<QuizQuestion> questions;
  final VoidCallback? onQuizCompleted;
  final VoidCallback? onQuizExited;

  const QuizIntroScreen({
    Key? key,
    required this.quizTitle,
    required this.quizDescription,
    required this.quizImage,
    required this.questions,
    this.onQuizCompleted,
    this.onQuizExited,
  }) : super(key: key);

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // Rimosso il Container con width fissa per lasciare l'AlertDialog dimensionarsi automaticamente
          // Il Column interno si adatterà al contenuto
          content: Column( // Era un Container, ora è direttamente il Column
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  'Vuoi davvero uscire dal Quiz?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(), // Close dialog
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007BFF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'Rimani nel Quiz',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog immediately
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            onQuizExited?.call(); // Notify parent about exit
                            Navigator.of(context).popUntil(ModalRoute.withName(QuizSelectionScreen.routeName));
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF3B30),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0,
                          padding: EdgeInsets.zero,
                        ),
                        child: const Text(
                          'Esci dal Quiz',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Lascio actions vuoti, dato che i pulsanti sono nel content
          actions: const [],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Sfondo bianco come da design
      appBar: AppBar( // AppBar con solo il tasto indietro come da design
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => _showExitConfirmation(context),
        ),
        // Rimossa la sezione 'title' con l'ora e le icone di segnale
        // Rimossa la sezione 'actions' con le icone di segnale/wifi/batteria
        // Questo rende l'AppBar pulita come richiesto.
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            RichText( // Titolo "Pronto per il Quiz?" dinamico
              textAlign: TextAlign.center,
              // Rimosso 'const' qui perché contiene un TextSpan dinamico
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
                  const TextSpan(text: 'Pronto per '),
                  TextSpan(
                    text: '$quizTitle Quiz?', // Usa il titolo dinamico
                    style: const TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text( // Descrizione dinamica
              quizDescription,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text( // "Buona fortuna!"
              'Buona fortuna!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            // Immagine dinamica basata su quizImage
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  quizImage, // Usa l'immagine passata dinamicamente
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback se l'immagine non viene trovata
                    return Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[300],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(
                        questions: questions,
                        onQuizCompleted: onQuizCompleted,
                        onQuizExited: onQuizExited,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Inizia il Quiz!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: 0, // Rimane 0 per Home
        onTap: (index) {
          switch (index) {
            case 0: // Home
              Navigator.of(context).popUntil(ModalRoute.withName(QuizSelectionScreen.routeName));
              break;
            case 1: // Conversazioni
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Conversazioni in arrivo')),
              );
              break;
            case 2: // Impostazioni
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Impostazioni in arrivo')),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Conversazioni',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Impostazioni',
          ),
        ],
      ),
    );
  }
}
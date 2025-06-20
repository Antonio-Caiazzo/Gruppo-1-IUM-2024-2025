// lib/screens/quiz_results_screen.dart
import 'package:flutter/material.dart';
import 'quiz_selection_screen.dart';
import '../models/quiz_models.dart';

class QuizResultsScreen extends StatelessWidget {
  final QuizResult result;
  final VoidCallback? onQuizCompleted;

  const QuizResultsScreen({
    Key? key,
    required this.result,
    this.onQuizCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const SizedBox(), // Nessun pulsante indietro su questa schermata
        centerTitle: true,
        title: const Text(
          '9:41',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.signal_cellular_4_bar, color: Colors.black, size: 16),
                SizedBox(width: 4),
                Icon(Icons.wifi, color: Colors.black, size: 16),
                SizedBox(width: 4),
                Icon(Icons.battery_full, color: Colors.black, size: 16),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    height: 1.2,
                  ),
                  children: [
                    TextSpan(text: 'Quiz '),
                    TextSpan(
                      text: 'completato!',
                      style: TextStyle(color: Color(0xFF00BFFF)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Ogni risposta conta, e hai dato il massimo.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Preparati per i prossimi Quiz.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Bravo! Continua così!',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF00BFFF),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatCard(
                    icon: Icons.check_circle,
                    color: const Color(0xFF00BFFF),
                    value: '${result.correctAnswers}',
                    label: 'Corrette',
                  ),
                  const SizedBox(width: 32),
                  _buildStatCard(
                    icon: Icons.cancel,
                    color: Colors.red,
                    value: '${result.incorrectAnswers}',
                    label: 'Errate',
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                height: 200,
                width: 200,
                child: Image.asset(
                  'assets/trophy.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.amber[100],
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.emoji_events,
                            size: 100,
                            color: Colors.amber,
                          ),
                          SizedBox(height: 12),
                          Text(
                            '🎉',
                            style: TextStyle(fontSize: 32),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                height: 56,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: ElevatedButton(
                  onPressed: () {
                    if (onQuizCompleted != null) {
                      onQuizCompleted!();
                    }
                    Navigator.of(context).popUntil(ModalRoute.withName(QuizSelectionScreen.routeName));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00BFFF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text(
                    'Torna alla pagina dei Quiz',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF00BFFF),
          unselectedItemColor: Colors.grey[600],
          currentIndex: 0, // Imposta 0 per selezionare 'Home' all'inizio
          selectedFontSize: 12,
          unselectedFontSize: 12,
          iconSize: 24,
          onTap: (index) {
            switch (index) {
              case 0: // Home
              // Se sei già sulla Home o vuoi tornare alla selezione quiz
                Navigator.of(context).popUntil(ModalRoute.withName(QuizSelectionScreen.routeName));
                break;
              case 1: // Conversazioni
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Conversazioni in arrivo'),
                    backgroundColor: Color(0xFF00BFFF),
                  ),
                );
                break;
              case 2: // Impostazioni
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Impostazioni in arrivo'),
                    backgroundColor: Color(0xFF00BFFF),
                  ),
                );
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home), // Icona per Home
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat), // Icona per Conversazioni
              label: 'Conversazioni',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings), // Icona per Impostazioni
              label: 'Impostazioni',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
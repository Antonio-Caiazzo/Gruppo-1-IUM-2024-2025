// lib/screens/quiz_results_screen.dart
import 'package:flutter/material.dart';
import 'quiz_selection_screen.dart';
import '../models/quiz_models.dart';
import '../widgets/student_bottom_nav_bar.dart';

class QuizResultsScreen extends StatelessWidget {
  final QuizResult result;
  final VoidCallback? onQuizCompleted;
  final String name;
  final String surname;
  final String classCode;

  const QuizResultsScreen({
    Key? key,
    required this.result,
    required this.name,
    required this.surname,
    required this.classCode,
    this.onQuizCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                          Text('🎉', style: TextStyle(fontSize: 32)),
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizSelectionScreen(
                          name: name,
                          surname: surname,
                          classCode: classCode,
                        ),
                      ),
                      (route) => false,
                    );
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
      bottomNavigationBar: StudentBottomNavigationBar(
        currentIndex: 0,
        name: name,
        surname: surname,
        classCode: classCode,
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

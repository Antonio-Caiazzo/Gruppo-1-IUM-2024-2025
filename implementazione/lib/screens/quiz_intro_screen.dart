import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/quiz_models.dart';
import 'quiz_screen.dart';
import '../widgets/student_bottom_nav_bar.dart';

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

  String getIntroPrefix() {
    final lower = quizTitle.toLowerCase();
    return lower.contains('rivoluzione') ? 'sulla' : "sull'";
  }

  @override
  Widget build(BuildContext context) {
    // Recupera i parametri di navigazione (es. nome, cognome, classe)
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>?;

    final name = args?['name'] ?? 'Mario';
    final surname = args?['surname'] ?? 'Rossi';
    final classCode = args?['classCode'] ?? '3C';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                children: [
TextSpan(text: 'Pronto per il quiz ${getIntroPrefix()} '),

                  TextSpan(
                    text: quizTitle,
                    style: const TextStyle(color: AppColors.primary),
                  ),
                  const TextSpan(text: '?'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              quizDescription,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Buona fortuna!',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
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
                  quizImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 80),
                    ),
                  ),
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
                      builder: (_) => QuizScreen(
                        questions: questions,
                        onQuizCompleted: onQuizCompleted,
                        onQuizExited: onQuizExited,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Inizia il Quiz!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: StudentBottomNavigationBar(
        currentIndex: -1,
        name: name,
        surname: surname,
        classCode: classCode,
      ),
    );
  }
}

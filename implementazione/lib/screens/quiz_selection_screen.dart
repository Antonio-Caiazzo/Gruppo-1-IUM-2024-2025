import 'package:flutter/material.dart';
import '../data/quiz_data.dart';
import '../models/quiz_models.dart';
import '../constants/colors.dart';
import 'quiz_intro_screen.dart';
import '../widgets/student_bottom_nav_bar.dart';
import 'home_student_screen.dart';
import 'conversations_student_screen.dart';
import 'settings_student_screen.dart';

class QuizSelectionScreen extends StatelessWidget {
  static const String routeName = '/quizSelection';

  final String name;
  final String surname;
  final String classCode;

  const QuizSelectionScreen({
    super.key,
    required this.name,
    required this.surname,
    required this.classCode,
  });

  void _navigateToQuiz(
    BuildContext context, {
    required String title,
    required String description,
    required String image,
    required List<QuizQuestion> questions,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizIntroScreen(
          quizTitle: title,
          quizDescription: description,
          quizImage: image,
          questions: questions,
          onQuizCompleted: () => Navigator.of(
            context,
          ).popUntil(ModalRoute.withName(QuizSelectionScreen.routeName)),
          onQuizExited: () => Navigator.of(
            context,
          ).popUntil(ModalRoute.withName(QuizSelectionScreen.routeName)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'Quiz',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text(
              'Seleziona un periodo storico',
              style: TextStyle(fontSize: 18, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildQuizCard(
                    context,
                    title: 'Impero Romano',
                    imagePath: 'assets/colosseum.png',
                    onTap: () => _navigateToQuiz(
                      context,
                      title: 'Impero Romano',
                      description:
                          'Inizia il quiz e dimostra la tua conoscenza sull\'Impero Romano.',
                      image: 'assets/colosseum.png',
                      questions: romanEmpireQuestions,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildQuizCard(
                    context,
                    title: 'Rivoluzione Francese',
                    imagePath: 'assets/rivoluzione.png',
                    onTap: () => _navigateToQuiz(
                      context,
                      title: 'Rivoluzione Francese',
                      description:
                          'Metti alla prova le tue conoscenze sulla Rivoluzione Francese!',
                      image: 'assets/rivoluzione.png',
                      questions: frenchRevolutionQuestions,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: StudentBottomNavigationBar(
        currentIndex: -1,
        name: name,
        surname: surname,
        classCode: classCode,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeStudentScreen(
                    name: name,
                    surname: surname,
                    classCode: classCode,
                  ),
                ),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ConversationsStudentScreen(
                    name: name,
                    surname: surname,
                    classCode: classCode,
                  ),
                ),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsStudentScreen(
                    name: name,
                    surname: surname,
                    classCode: classCode,
                  ),
                ),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildQuizCard(
    BuildContext context, {
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 260,
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
              flex: 4,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey[400],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
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

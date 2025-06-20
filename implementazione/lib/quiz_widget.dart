// quiz_widget.dart
import 'package:flutter/material.dart';
import 'screens/quiz_intro_screen.dart';
import 'data/quiz_data.dart'; // Importa i dati dei quiz

class QuizWidget extends StatelessWidget {
  final VoidCallback? onQuizCompleted;
  final VoidCallback? onQuizExited;

  const QuizWidget({
    Key? key,
    this.onQuizCompleted,
    this.onQuizExited,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // QuizWidget directly provides the QuizIntroScreen.
    // The navigation within the quiz (Intro -> Quiz -> Results)
    // is handled by pushing new MaterialPageRoutes.
    // The callbacks are then used to signal the parent application
    // (which launched QuizWidget) when the quiz flow is done or exited.
    return QuizIntroScreen(
      quizTitle: 'Impero Romano',
      quizDescription: 'Inizia il quiz e dimostra la tua conoscenza sull\'Impero Romano.',
      quizImage: 'assets/colosseum.png',
      questions: romanEmpireQuestions, // Example questions
      onQuizCompleted: onQuizCompleted, // Passes the callback from its parent
      onQuizExited: onQuizExited,       // Passes the callback from its parent
    );
  }
}
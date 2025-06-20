// lib/models/quiz_models.dart

class QuizQuestion {
  final String question;
  final List<String> answers;
  final int correctAnswerIndex;
  final String? imagePath; // Optional image for the question

  QuizQuestion({
    required this.question,
    required this.answers,
    required this.correctAnswerIndex,
    this.imagePath,
  });
}

class QuizResult {
  final int correctAnswers;
  final int incorrectAnswers;
  final int totalQuestions;
  final List<int?> userAnswers;
  final List<int> correctAnswerIndices;

  QuizResult({
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.totalQuestions,
    required this.userAnswers,
    required this.correctAnswerIndices,
  });
}
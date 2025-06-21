// lib/screens/quiz_screen.dart
import 'package:flutter/material.dart';
import '../models/quiz_models.dart';
import 'quiz_results_screen.dart';
import 'quiz_selection_screen.dart'; // Import for routeName

class QuizScreen extends StatefulWidget {
  final List<QuizQuestion> questions;
  final VoidCallback? onQuizCompleted;
  final VoidCallback? onQuizExited;

  const QuizScreen({
    Key? key,
    required this.questions,
    this.onQuizCompleted,
    this.onQuizExited,
  }) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  List<int?> selectedAnswers = [];
  int? lastSelectedAnswerIndex;
  bool showFeedback = false;

  @override
  void initState() {
    super.initState();
    selectedAnswers = List<int?>.filled(widget.questions.length, null);
  }

  void selectAnswer(int answerIndex) {
    if (showFeedback) {
      return;
    }
    setState(() {
      selectedAnswers[currentQuestionIndex] = answerIndex;
      lastSelectedAnswerIndex = answerIndex;
    });
  }

  void handleButtonPress() {
    if (selectedAnswers[currentQuestionIndex] == null && !showFeedback) {
      return;
    }

    if (!showFeedback) {
      setState(() {
        showFeedback = true;
      });
    } else {
      if (selectedAnswers[currentQuestionIndex] == widget.questions[currentQuestionIndex].correctAnswerIndex) {
        score++;
      }

      if (currentQuestionIndex < widget.questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          lastSelectedAnswerIndex = null;
          showFeedback = false;
        });
      } else {
        navigateToResults();
      }
    }
  }

  void navigateToResults() {
    List<int> correctAnswerIndices = [];
    for (var q in widget.questions) {
      correctAnswerIndices.add(q.correctAnswerIndex);
    }

    final result = QuizResult(
      correctAnswers: score,
      incorrectAnswers: widget.questions.length - score,
      totalQuestions: widget.questions.length,
      userAnswers: selectedAnswers.map((e) => e ?? -1).toList(),
      correctAnswerIndices: correctAnswerIndices,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizResultsScreen(
          result: result,
          onQuizCompleted: widget.onQuizCompleted,
        ),
      ),
    );
  }

  void showExitConfirmation() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
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
                            backgroundColor: const Color(0xFFFF3B30),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: 0,
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            'Esci dal quiz',
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
                              widget.onQuizExited?.call(); // Notify parent about exit
                              Navigator.of(context).popUntil(ModalRoute.withName(QuizSelectionScreen.routeName));
                            });
                          },
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
                  ],
                ),
              ],
            ),
          ),
          actions: [],
        );
      },
    );
  }

  Widget buildQuestionImage() {
    final currentQuestion = widget.questions[currentQuestionIndex];
    if (currentQuestion.imagePath != null) {
      return Container(
        height: 200,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20),
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
            currentQuestion.imagePath!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.amber[100],
                ),
                child: const Center(
                  child: Icon(
                    Icons.image,
                    size: 60,
                    color: Colors.amber,
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Color? getAnswerBorderColor(int index) {
    if (!showFeedback) {
      return selectedAnswers[currentQuestionIndex] == index ? Colors.blue : Colors.grey[300];
    } else {
      int correctIndex = widget.questions[currentQuestionIndex].correctAnswerIndex;
      if (index == correctIndex) {
        return Colors.green;
      } else if (index == lastSelectedAnswerIndex) {
        return Colors.red;
      } else {
        return Colors.grey[300];
      }
    }
  }

  Color? getAnswerBackgroundColor(int index) {
    if (!showFeedback) {
      return selectedAnswers[currentQuestionIndex] == index ? Colors.blue[50] : Colors.white;
    } else {
      int correctIndex = widget.questions[currentQuestionIndex].correctAnswerIndex;
      if (index == correctIndex) {
        return Colors.green[50];
      } else if (index == lastSelectedAnswerIndex) {
        return Colors.red[50];
      } else {
        return Colors.white;
      }
    }
  }

  Color getAnswerTextColor(int index) {
    if (!showFeedback) {
      return selectedAnswers[currentQuestionIndex] == index ? Colors.blue[800]! : Colors.black87;
    } else {
      int correctIndex = widget.questions[currentQuestionIndex].correctAnswerIndex;
      if (index == correctIndex) {
        return Colors.green[800]!;
      } else if (index == lastSelectedAnswerIndex) {
        return Colors.red[800]!;
      } else {
        return Colors.black87;
      }
    }
  }

  IconData? getAnswerIcon(int index) {
    if (!showFeedback) {
      return null;
    } else {
      int correctIndex = widget.questions[currentQuestionIndex].correctAnswerIndex;
      if (index == correctIndex) {
        return Icons.check;
      } else if (index == lastSelectedAnswerIndex) {
        return Icons.close;
      }
      return null;
    }
  }

  Color? getAnswerIconColor(int index) {
    if (!showFeedback) {
      return null;
    } else {
      int correctIndex = widget.questions[currentQuestionIndex].correctAnswerIndex;
      if (index == correctIndex) {
        return Colors.white;
      } else if (index == lastSelectedAnswerIndex) {
        return Colors.white;
      }
      return null;
    }
  }

  Color? getAnswerCircleColor(int index) {
    if (!showFeedback) {
      return selectedAnswers[currentQuestionIndex] == index ? Colors.blue : Colors.transparent;
    } else {
      int correctIndex = widget.questions[currentQuestionIndex].correctAnswerIndex;
      if (index == correctIndex) {
        return Colors.green;
      } else if (index == lastSelectedAnswerIndex) {
        return Colors.red;
      }
      return Colors.transparent;
    }
  }

  Color getAnswerCircleBorderColor(int index) {
    if (!showFeedback) {
      return selectedAnswers[currentQuestionIndex] == index ? Colors.blue : Colors.grey[400]!;
    } else {
      int correctIndex = widget.questions[currentQuestionIndex].correctAnswerIndex;
      if (index == correctIndex) {
        return Colors.green;
      } else if (index == lastSelectedAnswerIndex) {
        return Colors.red;
      }
      return Colors.grey[400]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: showExitConfirmation,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: (currentQuestionIndex + 1) / widget.questions.length,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                      minHeight: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '${currentQuestionIndex + 1}/${widget.questions.length}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildQuestionImage(),

                  Text(
                    currentQuestion.question,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 30),

                  ...List.generate(
                    currentQuestion.answers.length,
                        (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: showFeedback ? null : () => selectAnswer(index),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: getAnswerBackgroundColor(index),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: getAnswerBorderColor(index)!,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: getAnswerCircleColor(index),
                                      border: Border.all(
                                        color: getAnswerCircleBorderColor(index),
                                        width: 2,
                                      ),
                                    ),
                                    child: getAnswerIcon(index) != null
                                        ? Icon(
                                      getAnswerIcon(index),
                                      size: 16,
                                      color: getAnswerIconColor(index),
                                    )
                                        : null,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      currentQuestion.answers[index],
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: getAnswerTextColor(index),
                                        fontWeight: (showFeedback && (index == currentQuestion.correctAnswerIndex || index == lastSelectedAnswerIndex))
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (selectedAnswers[currentQuestionIndex] != null || showFeedback) ? handleButtonPress : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  showFeedback
                      ? (currentQuestionIndex < widget.questions.length - 1 ? 'Avanti' : 'Termina Quiz')
                      : 'Controlla',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
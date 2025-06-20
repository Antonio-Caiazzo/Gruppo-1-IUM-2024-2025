// quiz_runner.dart
import 'package:flutter/material.dart';
import 'package:historia/screens/quiz_selection_screen.dart'; // <--- CORREZIONE QUI: USA 'historia'

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      initialRoute: QuizSelectionScreen.routeName, // Imposta la rotta iniziale
      routes: {
        QuizSelectionScreen.routeName: (context) => const QuizSelectionScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
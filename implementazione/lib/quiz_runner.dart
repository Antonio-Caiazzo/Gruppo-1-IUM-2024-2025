
import 'package:flutter/material.dart';
import 'package:historia/screens/quiz_selection_screen.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Roboto'),
      home: const QuizSelectionScreen(
        name: 'Mario',
        surname: 'Rossi',
        classCode: '3C',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

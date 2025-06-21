import 'package:flutter/material.dart';

class HomeStudentScreen extends StatelessWidget {
  final String name;
  final String classCode;

  const HomeStudentScreen({
    super.key,
    required this.name,
    required this.classCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Benvenuto $name\nClasse 3C 😃",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

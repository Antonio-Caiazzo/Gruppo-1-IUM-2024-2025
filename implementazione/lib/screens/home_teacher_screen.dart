import 'package:flutter/material.dart';

class HomeTeacherScreen extends StatelessWidget {
  const HomeTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Benvenuto Mr. Clarke 😃",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

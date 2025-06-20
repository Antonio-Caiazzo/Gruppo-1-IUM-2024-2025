import 'package:flutter/material.dart';
import 'login_teacher_screen.dart';
import 'login_student_screen.dart';

class ProfileSelectionScreen extends StatelessWidget {
  const ProfileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color(0xFF2CBDFB),
              padding: const EdgeInsets.all(24),
              child: const Text(
                "Seleziona il profilo",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginTeacherScreen()),
                );
              },
              child: Column(
                children: [
                  const Text(
                    "Insegnante",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Image.asset(
                    'assets/teacher.png',
                    height: 120,
                  ), // assicurati che l'immagine sia in assets
                ],
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginStudentScreen()),
                );
              },
              child: Column(
                children: [
                  const Text(
                    "Studente",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Image.asset('assets/student.png', height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

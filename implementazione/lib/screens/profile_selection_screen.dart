import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_teacher_screen.dart';
import 'login_student_screen.dart';

class ProfileSelectionScreen extends StatelessWidget {
  const ProfileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // imposta il colore della status bar
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF2CBDFB), // colore barra oraria
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Barra azzurra in alto (copre anche l'orario)
            Container(
              height: MediaQuery.of(context).padding.top + 80,
              width: double.infinity,
              color: const Color(0xFF2CBDFB),
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 16),
              child: const Text(
                "Seleziona il profilo",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Corpo centrale
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Insegnante
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginTeacherScreen(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          const Text(
                            "Insegnante",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Image.asset('assets/teacher.png', height: 200),
                        ],
                      ),
                    ),

                    const SizedBox(height: 60),

                    // Studente
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginStudentScreen(),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          const Text(
                            "Studente",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Image.asset('assets/student.png', height: 200),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

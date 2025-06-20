import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import 'home_student_screen.dart';

class LoginStudentScreen extends StatelessWidget {
  const LoginStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final codeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Accesso Studente")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(
              hintText: "Nome e Cognome",
              controller: nameController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: "Codice classe",
              controller: codeController,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: "Accedi",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeStudentScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

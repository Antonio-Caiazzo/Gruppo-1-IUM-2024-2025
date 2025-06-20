import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import 'home_teacher_screen.dart';

class RegisterTeacherScreen extends StatelessWidget {
  const RegisterTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final surnameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Registrazione")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: "Nome",
                    controller: nameController,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: CustomTextField(
                    hintText: "Cognome",
                    controller: surnameController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(hintText: "E-mail", controller: emailController),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: "Password",
              controller: passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // Torna al login insegnante
              },
              child: const Text(
                "Accedi",
                style: TextStyle(
                  color: Color(0xFF2CBDFB),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: "Registrati",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeTeacherScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import 'home_student_screen.dart';

class LoginStudentScreen extends StatefulWidget {
  const LoginStudentScreen({super.key});

  @override
  State<LoginStudentScreen> createState() => _LoginStudentScreenState();
}

class _LoginStudentScreenState extends State<LoginStudentScreen> {
  final nameController = TextEditingController();
  final classCodeController = TextEditingController();

  void _handleLogin() {
    final fullName = nameController.text.trim();
    final classCode = classCodeController.text.trim();

    if (fullName.isEmpty || classCode.isEmpty) {
      _showErrorDialog("Per favore compila tutti i campi.");
      return;
    }

    final firstName = fullName.split(" ").first;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            HomeStudentScreen(name: firstName, classCode: classCode),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 80, // larghezza fissa più snella
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Center(
              child: Text(
                'Accesso Studente',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "Nome e Cognome",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: "Mario Rossi",
              controller: nameController,
            ),
            const SizedBox(height: 16),
            const Text(
              "Codice classe",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              hintText: "CA3C2025",
              controller: classCodeController,
            ),
            const SizedBox(height: 24),
            Center(
              child: PrimaryButton(text: "Accedi", onPressed: _handleLogin),
            ),
          ],
        ),
      ),
    );
  }
}

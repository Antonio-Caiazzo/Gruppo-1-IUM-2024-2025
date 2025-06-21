import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import 'home_teacher_screen.dart';
import 'register_teacher_screen.dart';

class LoginTeacherScreen extends StatefulWidget {
  const LoginTeacherScreen({super.key});

  @override
  State<LoginTeacherScreen> createState() => _LoginTeacherScreenState();
}

class _LoginTeacherScreenState extends State<LoginTeacherScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool showPassword = false;

  Future<void> _handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog("Per favore compila tutti i campi.");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString("teacher_email");
    final savedPassword = prefs.getString("teacher_password");
    final savedName = prefs.getString("teacher_name") ?? "Mr. Clarke";

    if (savedEmail == null || savedPassword == null) {
      // Nessun dato salvato → login come Mr. Clarke
      _goToHome(name: "Mr. Clarke");
    } else if (email == savedEmail) {
      // Email corretta
      if (password == savedPassword) {
        _goToHome(name: savedName);
      } else {
        // Password errata
        _showErrorDialog("Credenziali non valide.");
      }
    } else {
      // Email non corrisponde → login come Mr. Clarke
      _goToHome(name: "Mr. Clarke");
    }
  }

  void _goToHome({required String name}) {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeTeacherScreen(name: name)),
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
                'Accesso Insegnante',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "E-mail",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            CustomTextField(hintText: "E-mail", controller: emailController),
            const SizedBox(height: 16),
            const Text(
              "Password",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: !showPassword,
              decoration: InputDecoration(
                hintText: 'Password',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    showPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () => setState(() => showPassword = !showPassword),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: PrimaryButton(text: "Accedi", onPressed: _handleLogin),
            ),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RegisterTeacherScreen(),
                  ),
                ),
                child: const Text(
                  "Registrati",
                  style: TextStyle(
                    color: AppColors.primary,
                    decoration: TextDecoration.none, // rimuove sottolineatura
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

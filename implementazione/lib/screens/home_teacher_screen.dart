import 'package:flutter/material.dart';
import 'login_teacher_screen.dart';

class HomeTeacherScreen extends StatelessWidget {
  final String name;

  const HomeTeacherScreen({super.key, this.name = "Mr. Clarke"});

  Future<void> _logout(BuildContext context) async {
    // Nessuna cancellazione dei dati!
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginTeacherScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Benvenuto $name 😃",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

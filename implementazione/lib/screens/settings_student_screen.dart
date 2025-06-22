import 'package:flutter/material.dart';
import '../widgets/student_bottom_nav_bar.dart';

class SettingsStudentScreen extends StatelessWidget {
  final String name;
  final String surname;
  final String classCode;

  const SettingsStudentScreen({
    super.key,
    required this.name,
    required this.surname,
    required this.classCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Impostazioni",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 64),
              _buildField("Nome", name),
              const SizedBox(height: 32),
              _buildField("Cognome", surname),
              const SizedBox(height: 32),
              _buildField("Classe", classCode),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Esci",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: StudentBottomNavigationBar(
        currentIndex: 2,
        name: name,
        surname: surname,
        classCode: classCode,
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "$label: ",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

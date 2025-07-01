import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/student_bottom_nav_bar.dart';
import 'conversation_screen.dart';

class CharacterDetailScreen extends StatelessWidget {
  final String name;
  final String surname;
  final String classCode;
  final String characterName;
  final String characterImage;
  final String characterDescription;

  const CharacterDetailScreen({
    super.key,
    required this.name,
    required this.surname,
    required this.classCode,
    required this.characterName,
    required this.characterImage,
    required this.characterDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(
          characterName,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(characterImage, height: 200),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  characterDescription,
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 18, // Aumentato per leggibilità
                    height: 1.6, // Migliorata spaziatura tra righe
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ConversationScreen(
                        characterName: characterName,
                        characterImage: characterImage,
                        name: name,
                        surname: surname,
                        classCode: classCode,
                      ),
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: const Text(
                  'Avvia Conversazione',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: StudentBottomNavigationBar(
        currentIndex: -1,
        name: name,
        surname: surname,
        classCode: classCode,
      ),
    );
  }
}

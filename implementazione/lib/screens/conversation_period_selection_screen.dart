import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/student_bottom_nav_bar.dart';
import 'character_detail_screen.dart';

class ConversationPeriodSelectionScreen extends StatelessWidget {
  final String name;
  final String surname;
  final String classCode;

  const ConversationPeriodSelectionScreen({
    super.key,
    required this.name,
    required this.surname,
    required this.classCode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Nuova conversazione',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text(
              'Seleziona un periodo storico',
              style: TextStyle(fontSize: 18, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _buildPeriodCard(
                    context,
                    title: 'Impero Romano',
                    imagePath: 'assets/colosseum.png',
                    characterName: 'Giulio Cesare',
                    characterImage: 'assets/caesar.png',
                    characterDescription:
                        'Giulio Cesare è un abile generale e uomo politico romano, protagonista del I secolo a.C., noto per la conquista della Gallia e per il suo ruolo decisivo nella crisi della Repubblica romana. Ambizioso e carismatico, accresce il proprio potere fino a farsi nominare dittatore a vita, sfidando l\'autorità del Senato.',
                  ),
                  const SizedBox(height: 24),
                  _buildPeriodCard(
                    context,
                    title: 'Rivoluzione Francese',
                    imagePath: 'assets/rivoluzione.png',
                    characterName: 'Napoleone Bonaparte',
                    characterImage: 'assets/generale.jpg',
                    characterDescription:
                        'Napoleone Bonaparte fu un brillante generale e statista francese, protagonista della Rivoluzione Francese e imperatore dei francesi. Con la sua intelligenza strategica e ambizione, trasformò l\'Europa e promosse riforme sociali, lasciando un\'impronta duratura nella storia.',
                  ),
                ],
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

  Widget _buildPeriodCard(
    BuildContext context, {
    required String title,
    required String imagePath,
    required String characterName,
    required String characterImage,
    required String characterDescription,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CharacterDetailScreen(
              name: name,
              surname: surname,
              classCode: classCode,
              characterName: characterName,
              characterImage: characterImage,
              characterDescription: characterDescription,
            ),
          ),
        );
      },
      child: Container(
        height: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
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

import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../screens/quiz_selection_screen.dart';
import '../widgets/student_bottom_nav_bar.dart';
import 'conversations_student_screen.dart';
import 'settings_student_screen.dart';
import 'schermata_domande.dart';

class HomeStudentScreen extends StatefulWidget {
  final String name;
  final String surname;
  final String classCode;

  const HomeStudentScreen({
    super.key,
    required this.name,
    required this.surname,
    required this.classCode,
  });

  @override
  State<HomeStudentScreen> createState() => _HomeStudentScreenState();
}

class _HomeStudentScreenState extends State<HomeStudentScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildHomeContent(),
      bottomNavigationBar: StudentBottomNavigationBar(
        currentIndex: _selectedIndex,
        name: widget.name,
        surname: widget.surname,
        classCode: widget.classCode,
        onTap: (index) {
          if (index == _selectedIndex) return;

          switch (index) {
            case 0:
              break; // siamo già in home
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ConversationsStudentScreen(
                    name: widget.name,
                    surname: widget.surname,
                    classCode: widget.classCode,
                  ),
                ),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsStudentScreen(
                    name: widget.name,
                    surname: widget.surname,
                    classCode: widget.classCode,
                  ),
                ),
              );
              break;
          }
        },
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        const SizedBox(height: 120),
        Text(
          'Benvenuto ${widget.name} 😀',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Classe 3C',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _GridTile(
                  label: "Nuova\nconversazione",
                  assetPath: "assets/nuova_conversazione.png",
                  onTap: () {},
                ),
                _GridTile(
                  label: "Quiz",
                  assetPath: "assets/quiz.png",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizSelectionScreen(
                        name: widget.name,
                        surname: widget.surname,
                        classCode: widget.classCode,
                      ),
                    ),
                  ),
                ),
                _GridTile(
                  label: "Conversazioni",
                  assetPath: "assets/conversazioni.png",
                  onTap: () {},
                ),
                _GridTile(
                  label: "Domande",
                  assetPath: "assets/domande.png",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => SchermataDomande()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GridTile extends StatelessWidget {
  final String label;
  final String assetPath;
  final VoidCallback onTap;

  const _GridTile({
    required this.label,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(child: Image.asset(assetPath, fit: BoxFit.contain)),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

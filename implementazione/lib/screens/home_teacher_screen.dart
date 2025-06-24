import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/teacher_bottom_nav_bar.dart';
import 'classi_screen.dart';
import 'conversazioni_screen.dart'; // Import the new screen

class HomeTeacherScreen extends StatefulWidget {
  final String name;
  final String surname;

  const HomeTeacherScreen({
    super.key,
    required this.name,
    required this.surname,
  });

  @override
  State<HomeTeacherScreen> createState() => _HomeTeacherScreenState();
}

class _HomeTeacherScreenState extends State<HomeTeacherScreen> {
  int _selectedIndex = 0; // This seems to be for a different navigation system not fully present here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _buildHomeContent(),
      // The bottom navigation bar here seems to be a custom widget.
      // If it handles internal navigation, ensure its 'onTap' logic aligns.
      // For now, I'm assuming it doesn't automatically push routes,
      // so the _GridTile onTap needs to explicitly push the ConversazioniScreen.
      bottomNavigationBar: TeacherBottomNavigationBar(
        currentIndex: _selectedIndex,
        name: widget.name,
        surname: widget.surname,
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        const SizedBox(height: 100),
        Text(
          'Benvenuto ${widget.name} 😀',
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
                  label: "Conversazioni",
                  assetPath: "assets/conversazioni.png",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ConversazioniScreen()), // Navigate to ConversazioniScreen
                    );
                  },
                ),
                _GridTile(
                  label: "Domande",
                  assetPath: "assets/domande.png",
                  onTap: () {
                    // TODO: Implement navigation for Domande
                  },
                ),
                _GridTile(
                  label: "Classi",
                  assetPath: "assets/nuova_conversazione.png", // Assuming this is the correct asset for Classi
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClassiScreen()),
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
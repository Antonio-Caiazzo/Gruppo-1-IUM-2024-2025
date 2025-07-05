import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../screens/home_teacher_screen.dart';
import '../screens/settings_teacher_screen.dart';
import '../screens/conversazioni_screen.dart'; // Conversazioni docenti

class TeacherBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final String name;
  final String surname;
  final Function(int)? onTap;

  const TeacherBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.name,
    required this.surname,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex < 0 ? 0 : currentIndex,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      onTap: (index) {
        // Evita navigazione ridondante
        if (index == currentIndex) return;

        if (onTap != null) {
          onTap!(index);
        } else {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      HomeTeacherScreen(name: name, surname: surname),
                ),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ConversazioniScreen(name: name, surname: surname),
                ),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      SettingsTeacherScreen(name: name, surname: surname),
                ),
              );
              break;
          }
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Conversazioni'),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Impostazioni',
        ),
      ],
    );
  }
}

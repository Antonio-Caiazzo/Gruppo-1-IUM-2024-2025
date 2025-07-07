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

  void _navigate(BuildContext context, int index) {
    Widget screen;
    switch (index) {
      case 0:
        screen = HomeTeacherScreen(name: name, surname: surname);
        break;
      case 1:
        screen = ConversazioniScreen(name: name, surname: surname);
        break;
      case 2:
        screen = SettingsTeacherScreen(name: name, surname: surname);
        break;
      default:
        return;
    }

    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex >= 0 && currentIndex <= 2 ? currentIndex : 0,
      selectedItemColor: currentIndex == -1 ? Colors.grey : AppColors.primary,
      selectedLabelStyle: TextStyle(
        color: currentIndex == -1 ? Colors.grey : AppColors.primary,
      ),
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
      onTap: (index) {
        if (index == currentIndex) return;

        if (onTap != null) {
          onTap!(index);
        } else {
          _navigate(context, index);
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

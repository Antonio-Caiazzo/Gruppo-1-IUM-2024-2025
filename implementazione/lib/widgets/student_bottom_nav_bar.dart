import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../screens/home_student_screen.dart';
import '../screens/settings_student_screen.dart';
import '../screens/conversations_student_screen.dart';

class StudentBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final String name;
  final String surname;
  final String classCode;
  final Function(int)? onTap;

  const StudentBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.name,
    required this.surname,
    required this.classCode,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex < 0 ? 0 : currentIndex, // evita crash
      selectedItemColor: currentIndex < 0 ? Colors.grey : AppColors.primary,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      onTap: (index) {
        if (onTap != null) {
          onTap!(index);
        } else {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeStudentScreen(
                    name: name,
                    surname: surname,
                    classCode: classCode,
                  ),
                ),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ConversationsStudentScreen(
                    name: name,
                    surname: surname,
                    classCode: classCode,
                  ),
                ),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsStudentScreen(
                    name: name,
                    surname: surname,
                    classCode: classCode,
                  ),
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

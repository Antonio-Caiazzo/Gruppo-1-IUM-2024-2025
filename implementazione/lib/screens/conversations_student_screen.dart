import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/student_bottom_nav_bar.dart';

class ConversationsStudentScreen extends StatelessWidget {
  final String name;
  final String surname;
  final String classCode;

  const ConversationsStudentScreen({
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
        title: const Text(
          'Conversazioni',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const Center(
        child: Text('Conversazioni in arrivo!', style: TextStyle(fontSize: 20)),
      ),
      bottomNavigationBar: StudentBottomNavigationBar(
        currentIndex: 1,
        name: name,
        surname: surname,
        classCode: classCode,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'screens/profile_selection_screen.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF2CBDFB), // Azzurro
      statusBarIconBrightness: Brightness.light, // Icone bianche
    ),
  );

  runApp(const HistoriaApp());
}

class HistoriaApp extends StatelessWidget {
  const HistoriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HistorIA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const ProfileSelectionScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import '../screens/schermata_domande.dart';

void main() {
  runApp(const DomandeApp());
}

class DomandeApp extends StatelessWidget {
  const DomandeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Runner Domande',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: SchermataDomande(),
    );
  }
}

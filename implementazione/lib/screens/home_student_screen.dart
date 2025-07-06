import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../models/domanda_model.dart';
import '../screens/quiz_selection_screen.dart';
import '../widgets/student_bottom_nav_bar.dart';
import 'conversations_student_screen.dart';
import 'settings_student_screen.dart';
import 'schermata_domande.dart';
import 'conversation_period_selection_screen.dart';

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

class _HomeStudentScreenState extends State<HomeStudentScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _animation;

  // Lista condivisa di domande
  static final List<DomandaModel> domande = [
    DomandaModel(
      testo: "Come hanno costruito il Colosseo i romani?",
      data: DateTime(2025, 4, 15, 10, 30),
      stato: StatoDomanda.nuova,
      personaggio: "Giulio Cesare",
      immagineAsset: "assets/caesar.png",
    ),
    DomandaModel(
      testo: "Come hanno costruito il Foro i romani?",
      data: DateTime(2025, 4, 17, 16, 40),
      stato: StatoDomanda.incompleta,
      personaggio: "Giulio Cesare",
      immagineAsset: "assets/caesar.png",
    ),
    DomandaModel(
      testo: "Dove è nato Giulio Cesare?",
      data: DateTime(2025, 4, 17, 16, 40),
      stato: StatoDomanda.completa,
      personaggio: "Giulio Cesare",
      immagineAsset: "assets/caesar.png",
    ),
  ];

  bool get _hasPendingDomande {
    return domande.any(
      (d) =>
          d.stato == StatoDomanda.nuova || d.stato == StatoDomanda.incompleta,
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.7,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToIndex(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);

    Widget page;
    switch (index) {
      case 1:
        page = ConversationsStudentScreen(
          name: widget.name,
          surname: widget.surname,
          classCode: widget.classCode,
        );
        break;
      case 2:
        page = SettingsStudentScreen(
          name: widget.name,
          surname: widget.surname,
          classCode: widget.classCode,
        );
        break;
      default:
        return;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => page));
  }

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
        onTap: _navigateToIndex,
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
        ),
        const SizedBox(height: 8),
        Text(
          'Classe 3C',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConversationPeriodSelectionScreen(
                          name: widget.name,
                          surname: widget.surname,
                          classCode: widget.classCode,
                        ),
                      ),
                    );
                  },
                ),
                _GridTile(
                  label: "Quiz",
                  assetPath: "assets/quiz.png",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizSelectionScreen(
                          name: widget.name,
                          surname: widget.surname,
                          classCode: widget.classCode,
                        ),
                      ),
                    );
                  },
                ),
                _GridTile(
                  label: "Conversazioni",
                  assetPath: "assets/conversazioni.png",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConversationsStudentScreen(
                          name: widget.name,
                          surname: widget.surname,
                          classCode: widget.classCode,
                        ),
                      ),
                    );
                  },
                ),
                Stack(
                  children: [
                    _GridTile(
                      label: "Domande",
                      assetPath: "assets/domande.png",
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SchermataDomande(
                              name: widget.name,
                              surname: widget.surname,
                              classCode: widget.classCode,
                              domande: domande, // Passiamo la lista
                            ),
                          ),
                        );

                        // Se c'è stato un aggiornamento (es. domanda completata)
                        if (result == true) {
                          setState(() {});
                        }
                      },
                    ),
                    if (_hasPendingDomande)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: ScaleTransition(
                          scale: _animation,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                  ],
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

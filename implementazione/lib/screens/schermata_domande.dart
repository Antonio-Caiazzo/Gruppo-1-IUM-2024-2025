import 'package:flutter/material.dart';
import '../models/domanda_model.dart';
import 'conversation_screen.dart';
import '../widgets/student_bottom_nav_bar.dart';

class SchermataDomande extends StatefulWidget {
  final String name;
  final String surname;
  final String classCode;
  final List<DomandaModel> domande;

  const SchermataDomande({
    super.key,
    required this.name,
    required this.surname,
    required this.classCode,
    required this.domande,
  });

  @override
  State<SchermataDomande> createState() => _SchermataDomandeState();
}

class _SchermataDomandeState extends State<SchermataDomande> {
  List<DomandaModel> get domande => widget.domande;

  bool get hasPendingQuestions => domande.any(
    (d) => d.stato == StatoDomanda.nuova || d.stato == StatoDomanda.incompleta,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, hasPendingQuestions);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
            onPressed: () => Navigator.pop(context, hasPendingQuestions),
          ),
          title: const Text(
            "Domande",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: domande.asMap().entries.map((entry) {
              final index = entry.key;
              final domanda = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: _buildDomandaCard(domanda, index),
                ),
              );
            }).toList(),
          ),
        ),
        bottomNavigationBar: StudentBottomNavigationBar(
          currentIndex: -1,
          name: widget.name,
          surname: widget.surname,
          classCode: widget.classCode,
        ),
      ),
    );
  }

  Widget _buildDomandaCard(DomandaModel domanda, int index) {
    return GestureDetector(
      onTap: () => _onDomandaTapped(domanda, index),
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF42A5F5), width: 2.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  domanda.testo,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Montserrat',
                    color: Colors.black87,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatData(domanda.data),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _formatOrario(domanda.data),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                _buildStatoChip(domanda.stato),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF29B6F6),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: const Icon(Icons.play_arrow, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onDomandaTapped(DomandaModel domanda, int index) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ConversationScreen(
          characterName: domanda.personaggio,
          characterImage: domanda.immagineAsset,
          name: widget.name,
          surname: widget.surname,
          classCode: widget.classCode,
          isReadOnly: false,
          customTitle: domanda.personaggio,
          introMessage: domanda.testo,
          messages: [],
        ),
      ),
    );

    setState(() {
      if (result == true) {
        domande[index].stato = StatoDomanda.completa;
      } else {
        domande[index].stato = StatoDomanda.incompleta;
      }
    });
  }

  Widget _buildStatoChip(StatoDomanda stato) {
    late final String label;
    late final Color backgroundColor;
    late final Color textColor;

    switch (stato) {
      case StatoDomanda.nuova:
        label = "Nuova";
        backgroundColor = const Color(0xFFE3F2FD);
        textColor = const Color(0xFF1976D2);
        break;
      case StatoDomanda.incompleta:
        label = "Incompleta";
        backgroundColor = const Color(0xFFFFF3C4);
        textColor = const Color(0xFFE65100);
        break;
      case StatoDomanda.completa:
        label = "Completata";
        backgroundColor = const Color(0xFFE8F5E8);
        textColor = const Color(0xFF2E7D32);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  String _formatData(DateTime data) =>
      "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";

  String _formatOrario(DateTime data) =>
      "${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}";
}

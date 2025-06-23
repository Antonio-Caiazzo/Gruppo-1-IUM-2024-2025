import 'package:flutter/material.dart';
import '../models/domanda_model.dart';
import 'schermata_conversazione.dart';
import '../widgets/student_bottom_nav_bar.dart';

class SchermataDomande extends StatefulWidget {
  const SchermataDomande({super.key});

  @override
  State<SchermataDomande> createState() => _SchermataDomandeState();
}

class _SchermataDomandeState extends State<SchermataDomande> {
  final List<DomandaModel> domande = [
    DomandaModel(
      testo: "Come hanno costruito il Colosseo i romani?",
      data: DateTime(2025, 4, 15, 10, 30),
      stato: StatoDomanda.completa,
      personaggio: "Colosseo",
      immagineAsset: "assets/colosseum.png",
    ),
    DomandaModel(
      testo: "Come hanno costruito il Foro i romani?",
      data: DateTime(2025, 4, 17, 16, 40),
      stato: StatoDomanda.incompleta,
      personaggio: "Foro Romano",
      immagineAsset: "assets/forum.png",
    ),
    DomandaModel(
      testo: "Dove è nato Giulio Cesare?",
      data: DateTime(2025, 4, 17, 16, 40),
      stato: StatoDomanda.completa,
      personaggio: "Giulio Cesare",
      immagineAsset: "assets/caesar.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
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
      bottomNavigationBar: const StudentBottomNavigationBar(
        currentIndex: -1,
        name: 'Mario',
        surname: 'Rossi',
        classCode: '3C',
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatData(domanda.data),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      _formatOrario(domanda.data),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
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
        textAlign: TextAlign.center,
      ),
    );
  }

  void _onDomandaTapped(DomandaModel domanda, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SchermataConversazione(
          domanda: domanda,
          onRispostaInviata: (aggiornata) {
            setState(() {
              domande[index] = aggiornata;
            });
          },
        ),
      ),
    );
  }

  String _formatData(DateTime data) =>
      "${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}";

  String _formatOrario(DateTime data) =>
      "${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}";
}

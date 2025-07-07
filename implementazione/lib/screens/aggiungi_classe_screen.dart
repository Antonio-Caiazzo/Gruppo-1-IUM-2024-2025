import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/teacher_bottom_nav_bar.dart';

class AggiungiClasseScreen extends StatefulWidget {
  final String name;
  final String surname;

  const AggiungiClasseScreen({
    Key? key,
    required this.name,
    required this.surname,
  }) : super(key: key);

  @override
  _AggiungiClasseScreenState createState() => _AggiungiClasseScreenState();
}

class _AggiungiClasseScreenState extends State<AggiungiClasseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController annoController = TextEditingController();

  void _salvaClasse() {
    if (_formKey.currentState!.validate()) {
      final nuovaClasse = {
        'nome': nomeController.text.trim(),
        'anno': annoController.text.trim(),
      };
      Navigator.pop(context, nuovaClasse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Aggiungi classe',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        leading: const BackButton(),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nome della classe',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    hintText: 'Sezione',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci il nome della classe';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Anno Scolastico',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: annoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Anno',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci l\'anno scolastico';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Inserisci solo numeri';
                    }
                    return null;
                  },
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2CBDFB),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _salvaClasse,
                  child: const Text(
                    'Aggiungi',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: TeacherBottomNavigationBar(
        currentIndex: 0, // Imposta 0 per Home, puoi cambiarlo se necessario
        name: widget.name,
        surname: widget.surname,
      ),
    );
  }
}
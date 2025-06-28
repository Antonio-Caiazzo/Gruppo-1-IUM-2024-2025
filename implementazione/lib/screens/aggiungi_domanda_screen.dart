import 'package:flutter/material.dart';
import '../widgets/teacher_bottom_nav_bar.dart';

class AddQuestionScreen extends StatefulWidget {
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedPeriod;
  String _questionText = "";

  final List<String> periods = ["Impero Romano", "Rivoluzione Francese"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Aggiungi domanda"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Periodo Storico",
                  border: OutlineInputBorder(),
                ),
                value: _selectedPeriod,
                items: periods
                    .map(
                      (period) =>
                          DropdownMenuItem(value: period, child: Text(period)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPeriod = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Seleziona un periodo' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: "Domanda",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  _questionText = value;
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Inserisci una domanda'
                    : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, _questionText);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2CBDFB),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Aggiungi', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

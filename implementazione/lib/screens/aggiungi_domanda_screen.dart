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
              Center(
                child: SizedBox(
                  width: 300, 
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Periodo Storico",
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedPeriod,
                    items: periods
                        .map(
                          (period) => DropdownMenuItem(
                            value: period,
                            child: Text(period),
                          ),
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
                ),
              ),

              SizedBox(height: 24),
              Text(
                "Domanda",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF6F6F6), // Gray/01
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Inserisci la tua domanda...',
                  ),
                  onChanged: (value) {
                    _questionText = value;
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Inserisci una domanda'
                      : null,
                ),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, {
                      'text': _questionText,
                      'period': _selectedPeriod!,
                    });

                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2CBDFB),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Aggiungi',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

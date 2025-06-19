import 'package:flutter/material.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/input_field.dart';
import 'package:wellyess/widgets/dropdown_field.dart';
import 'package:wellyess/widgets/time_picker_field.dart';
import 'med_diary.dart';

class NewVisitaScreen extends StatefulWidget {
  const NewVisitaScreen({super.key});

  @override
  State<NewVisitaScreen> createState() => _NewVisitaScreenState();
}

class _NewVisitaScreenState extends State<NewVisitaScreen> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final List<String> _dateOptions = ['7 Maggio 2025', '8 Maggio 2025', '9 Maggio 2025'];
  String? _selectedDate;

  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      onBackPressed: () => Navigator.of(context).pop(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Aggiungi Visita',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Divider(color: Colors.grey.shade300),
              const SizedBox(height: 24),

              const Text(
                'Tipo di Visita',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              InputField(
                controller: TextEditingController(),
                placeholder: '',
              ),
              const SizedBox(height: 16),

              const Text(
                'Luogo della Visita',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              InputField(
                controller: _locationController,
                placeholder: '',
              ),
              const SizedBox(height: 16),

              const Text(
                'Data della Visita',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              DropdownField(
                options: _dateOptions,
                value: _selectedDate,
                placeholder: '',
                onChanged: (newValue) {
                  setState(() {
                    _selectedDate = newValue;
                  });
                },
              ),
              const SizedBox(height: 16),

              const Text(
                'Orario',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TimePickerField(
                value: _selectedTime,
                placeholder: '',
                onChanged: (newTime) {
                  setState(() {
                    _selectedTime = newTime;
                  });
                },
              ),
              const SizedBox(height: 16),

              const Text(
                'Note',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              InputField(
                controller: _notesController,
                placeholder: '',
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MedDiaryPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5DB47F),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Salva',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Annulla',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
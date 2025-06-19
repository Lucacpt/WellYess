import 'package:flutter/material.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/input_field.dart';
import 'package:wellyess/widgets/dropdown_field.dart';
import 'package:wellyess/widgets/time_picker_field.dart';
import 'package:wellyess/widgets/confirm_popup.dart';
import 'package:wellyess/widgets/custom_main_button.dart';

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

  Future<bool> _showExitConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDialog(
        titleText: 'Vuoi davvero annullare?\nTutti i dati inseriti andranno persi.',
        cancelButtonText: 'No, riprendi',
        confirmButtonText: 'Sì, esci',
        onCancel: () => Navigator.of(context).pop(false),
        onConfirm: () => Navigator.of(context).pop(true),
      ),
    );
    return result == true;
  }

  @override
  void dispose() {
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _showExitConfirmation,
      child: BaseLayout(
        onBackPressed: () async {
          if (await _showExitConfirmation()) {
            Navigator.of(context).pop();
          }
        },
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
                  placeholder: 'Es. Controllo cardiologico',
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
                  placeholder: 'Es. Ospedale San Luca, Salerno',
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
                  placeholder: 'Seleziona una data',
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
                  placeholder: 'Scegli un orario',
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
                  placeholder: 'Aggiungi note sulla visita',
                ),
                const SizedBox(height: 32),

                CustomMainButton(
                text: 'Salva',
                color: const Color(0xFF5DB47F),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Visita salvata con successo')),
                  );
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if (await _showExitConfirmation()) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    'Annulla',
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
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
      ),
    );
  }
}

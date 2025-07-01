import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:wellyess/models/appointment_model.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/input_field.dart';
import 'package:wellyess/widgets/custom_main_button.dart';
import 'package:wellyess/widgets/pop_up_conferma.dart';
import 'package:wellyess/widgets/time_picker_field.dart';
import 'package:wellyess/widgets/date_picker_field.dart'; // aggiungi questo import
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class NewVisitaScreen extends StatefulWidget {
  const NewVisitaScreen({Key? key}) : super(key: key);
  @override
  State<NewVisitaScreen> createState() => _NewVisitaScreenState();
}

class _NewVisitaScreenState extends State<NewVisitaScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final _tipoCtrl = TextEditingController();
  final _luogoCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  void _save() async {
    if (_selectedDate == null || _selectedTime == null) return;
    final box = Hive.box<AppointmentModel>('appointments');
    final app = AppointmentModel(
      tipoVisita: _tipoCtrl.text.trim(),
      luogo: _luogoCtrl.text.trim(),
      data: _selectedDate!,
      ora: DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      ),
      note: _noteCtrl.text.trim(),
    );
    await box.add(app);

    // mostra popup di conferma
    await showDialog(
      context: context,
      builder: (_) => const PopUpConferma(
        message: 'Visita salvata con successo',
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Accessibilità
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    return BaseLayout(
      onBackPressed: () => Navigator.of(context).pop(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // HEADER FISSO
          SizedBox(height: screenHeight * 0.02),
          Center(
            child: Text(
              'Aggiungi Visita',
              style: TextStyle(
                fontSize: (screenWidth * 0.08 * fontSizeFactor).clamp(22.0, 36.0),
                fontWeight: FontWeight.bold,
                color: highContrast ? Colors.black : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          // CONTENUTO SCORRIBILE
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04)
                  .copyWith(bottom: screenHeight * 0.01),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Testo informativo
                  Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: (screenWidth * 0.06 * fontSizeFactor).clamp(18.0, 28.0)),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                        child: Text(
                          "Compila tutti i campi per aggiungere una visita.",
                          style: TextStyle(
                            fontSize: (screenWidth * 0.038 * fontSizeFactor).clamp(15.0, 24.0),
                            fontStyle: FontStyle.italic,
                            color: highContrast ? Colors.black : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  Text('Tipo di visita',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: (screenWidth * 0.05 * fontSizeFactor).clamp(15.0, 22.0),
                          color: highContrast ? Colors.black : Colors.black)),
                  InputField(controller: _tipoCtrl, placeholder: 'Tipo di visita'),
                  SizedBox(height: screenHeight * 0.025),
                  Text('Luogo',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: (screenWidth * 0.05 * fontSizeFactor).clamp(15.0, 22.0),
                          color: highContrast ? Colors.black : Colors.black)),
                  InputField(controller: _luogoCtrl, placeholder: 'Luogo'),
                  SizedBox(height: screenHeight * 0.025),
                  Text('Data',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: (screenWidth * 0.05 * fontSizeFactor).clamp(15.0, 22.0),
                          color: highContrast ? Colors.black : Colors.black)),
                  DatePickerField(
                    value: _selectedDate,
                    placeholder: 'Seleziona data',
                    onChanged: (d) => setState(() => _selectedDate = d),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  Text('Orario',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: (screenWidth * 0.05 * fontSizeFactor).clamp(15.0, 22.0),
                          color: highContrast ? Colors.black : Colors.black)),
                  TimePickerField(
                    value: _selectedTime,
                    placeholder: 'Seleziona orario',
                    onChanged: (v) => setState(() => _selectedTime = v),
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  Text('Note',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: (screenWidth * 0.05 * fontSizeFactor).clamp(15.0, 22.0),
                          color: highContrast ? Colors.black : Colors.black)),
                  InputField(controller: _noteCtrl, placeholder: 'Note'),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04)
                .copyWith(bottom: screenHeight * 0.01, top: screenHeight * 0.01),
            child: CustomMainButton(
              text: 'Salva',
              color: const Color(0xFF5DB47F),
              onTap: _save,
            ),
          ),
        ],
      ),
    );
  }
}

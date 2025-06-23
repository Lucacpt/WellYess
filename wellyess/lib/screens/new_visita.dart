import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:wellyess/models/appointment_model.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/input_field.dart';
import 'package:wellyess/widgets/custom_main_button.dart';
import 'package:wellyess/widgets/pop_up_conferma.dart';  // <-- import popup

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
  final _noteCtrl  = TextEditingController();

  Future _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (d != null) setState(() => _selectedDate = d);
  }

  Future _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (t != null) setState(() => _selectedTime = t);
  }

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
    return BaseLayout(
      onBackPressed: () => Navigator.of(context).pop(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InputField(controller: _tipoCtrl, placeholder: 'Tipo di visita'),
            const SizedBox(height: 12),
            InputField(controller: _luogoCtrl, placeholder: 'Luogo'),
            const SizedBox(height: 12),

            // Date picker
            ListTile(
              title: Text(
                _selectedDate == null
                  ? 'Seleziona data'
                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              ),
              leading: const Icon(Icons.calendar_today),
              onTap: _pickDate,
            ),

            // Time picker
            ListTile(
              title: Text(
                _selectedTime == null
                  ? 'Seleziona orario'
                  : _selectedTime!.format(context),
              ),
              leading: const Icon(Icons.access_time),
              onTap: _pickTime,
            ),

            const SizedBox(height: 12),
            InputField(controller: _noteCtrl, placeholder: 'Note'),

            const Spacer(),
            CustomMainButton(text: 'Salva', color: const Color(0xFF5DB47F), onTap: _save),
          ],
        ),
      ),
    );
  }
}

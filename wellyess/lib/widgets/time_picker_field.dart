import 'package:flutter/material.dart';

class TimePickerField extends StatelessWidget {
  final TimeOfDay? value;
  final String placeholder;
  final ValueChanged<TimeOfDay> onChanged;

  const TimePickerField({
    super.key,
    required this.value,
    required this.placeholder,
    required this.onChanged,
  });

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: value ?? TimeOfDay.now(),
      // Forza il selettore a usare il formato 24 ore
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null && picked != value) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Formattazione manuale per la visualizzazione nel campo
    String displayText;
    if (value != null) {
      final hour = value!.hour.toString().padLeft(2, '0');
      final minute = value!.minute.toString().padLeft(2, '0');
      displayText = '$hour:$minute';
    } else {
      displayText = placeholder;
    }

    return GestureDetector(
      onTap: () => _selectTime(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: screenHeight * 0.018),
        child: Row(
          children: [
            Expanded(
              child: Text(
                displayText, // Usa la stringa formattata manualmente
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: value != null ? Colors.black : Colors.grey.shade600,
                ),
              ),
            ),
            Icon(Icons.access_time,
                color: Colors.grey, size: screenWidth * 0.06),
          ],
        ),
      ),
    );
  }
}
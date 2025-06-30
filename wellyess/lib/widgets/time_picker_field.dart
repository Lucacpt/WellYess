import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

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
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    final Color bgColor = highContrast ? Colors.yellow.shade700 : Colors.white;
    final Color textColor = highContrast ? Colors.black : Colors.grey; 
    final Color hintColor = highContrast ? Colors.black54 : Colors.grey;
    final Color iconColor = highContrast ? Colors.black : Colors.grey;

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
          color: bgColor,
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
          border: highContrast
              ? Border.all(color: Colors.black, width: 2)
              : null,
        ),
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: screenHeight * 0.018),
        child: Row(
          children: [
            Expanded(
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: (screenWidth * 0.04 * fontSizeFactor).clamp(14.0, 22.0),
                  color: textColor,
                  fontWeight: highContrast ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            Icon(
              Icons.access_time,
              color: iconColor,
              size: (screenWidth * 0.06 * fontSizeFactor).clamp(18.0, 28.0),
            ),
          ],
        ),
      ),
    );
  }
}
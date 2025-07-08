import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

// TimePickerField è un campo personalizzato che permette di selezionare un orario tramite un time picker
class TimePickerField extends StatelessWidget {
  final TimeOfDay? value;                  // Orario attualmente selezionato
  final String placeholder;                // Testo segnaposto se nessun orario è selezionato
  final ValueChanged<TimeOfDay> onChanged; // Callback quando viene selezionato un nuovo orario

  const TimePickerField({
    super.key,
    required this.value,
    required this.placeholder,
    required this.onChanged,
  });

  // Mostra il time picker e aggiorna l'orario se l'utente ne seleziona uno nuovo
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: value ?? TimeOfDay.now(), // Orario iniziale: quello selezionato o ora corrente
      builder: (BuildContext context, Widget? child) {
        // Forza il formato 24 ore per coerenza
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null && picked != value) {
      onChanged(picked); // Notifica il nuovo orario selezionato
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    // Colori adattati per l'accessibilità
    final Color bgColor = highContrast ? Colors.yellow.shade700 : Colors.white;
    final Color textColor = highContrast ? Colors.black : Colors.grey;
    final Color hintColor = highContrast ? Colors.black54 : Colors.grey;
    final Color iconColor = highContrast ? Colors.black : Colors.grey;

    // Formattazione manuale per la visualizzazione nel campo
    String displayText;
    if (value != null) {
      final hour = value!.hour.toString().padLeft(2, '0');
      final minute = value!.minute.toString().padLeft(2, '0');
      displayText = '$hour:$minute'; // Mostra l'orario selezionato
    } else {
      displayText = placeholder;     // Mostra il placeholder se nessun orario è selezionato
    }

    return GestureDetector(
      onTap: () => _selectTime(context), // Apre il time picker al tap
      child: Container(
        decoration: BoxDecoration(
          color: bgColor, // Sfondo adattato per contrasto
          borderRadius: BorderRadius.circular(screenWidth * 0.04), // Bordo arrotondato
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
          border: highContrast
              ? Border.all(color: Colors.black, width: 2) // Bordo nero se alto contrasto
              : null,
        ),
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: screenHeight * 0.018),
        child: Row(
          children: [
            // Testo dell'orario selezionato o placeholder
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
            // Icona orologio
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
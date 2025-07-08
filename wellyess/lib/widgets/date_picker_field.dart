import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

// Campo personalizzato che permette di selezionare una data tramite un date picker
class DatePickerField extends StatelessWidget {
  final DateTime? value;                // Valore attuale della data selezionata
  final String placeholder;             // Testo segnaposto se nessuna data è selezionata
  final ValueChanged<DateTime> onChanged; // Callback quando viene selezionata una nuova data

  const DatePickerField({
    super.key,
    required this.value,
    required this.placeholder,
    required this.onChanged,
  });

  // Mostra il date picker e aggiorna la data se l'utente ne seleziona una nuova
  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: value ?? now,                  // Data iniziale: quella selezionata o oggi
      firstDate: DateTime(now.year - 1),          // Data minima selezionabile: un anno fa
      lastDate: DateTime(now.year + 1),           // Data massima selezionabile: tra un anno
    );
    if (picked != null && picked != value) {
      onChanged(picked);                          // Notifica la nuova data selezionata
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
    final Color iconColor = highContrast ? Colors.black : Colors.grey;

    // Testo da mostrare: data formattata o placeholder
    String displayText;
    if (value != null) {
      displayText = DateFormat("d MMMM yyyy", "it_IT").format(value!);
    } else {
      displayText = placeholder;
    }

    return GestureDetector(
      onTap: () => _selectDate(context), // Apre il date picker al tap
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
            // Testo della data selezionata o placeholder
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
            // Icona calendario
            Icon(
              Icons.calendar_today,
              color: iconColor,
              size: (screenWidth * 0.06 * fontSizeFactor).clamp(18.0, 28.0),
            ),
          ],
        ),
      ),
    );
  }
}
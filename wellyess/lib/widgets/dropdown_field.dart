import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

// Campo a discesa personalizzato che si adatta alle impostazioni di accessibilità
class DropdownField extends StatelessWidget {
  final List<String> options;           // Opzioni disponibili nel menu a discesa
  final String? value;                  // Valore attualmente selezionato
  final String placeholder;             // Testo segnaposto se nessuna opzione è selezionata
  final ValueChanged<String?> onChanged; // Callback quando viene selezionata una nuova opzione

  const DropdownField({
    super.key,
    required this.options,
    required this.value,
    required this.placeholder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    return Semantics(
      label: placeholder,
      hint: 'Campo a scelta multipla. Premi per espandere le opzioni.',
      child: Container(
        decoration: BoxDecoration(
          color: highContrast ? Colors.yellow.shade700 : Colors.white, // Sfondo adattato per contrasto
          borderRadius: BorderRadius.circular(screenWidth * 0.04),     // Bordo arrotondato
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
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            // Testo segnaposto se nessuna opzione è selezionata
            hint: Text(
              placeholder,
              style: TextStyle(
                fontSize: screenWidth * 0.04 * fontSizeFactor,
                color: highContrast ? Colors.black : Colors.grey,
                fontWeight: highContrast ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            // Stile del testo delle opzioni
            style: TextStyle(
              fontSize: screenWidth * 0.04 * fontSizeFactor,
              color: highContrast ? Colors.black : Colors.black,
              fontWeight: highContrast ? FontWeight.bold : FontWeight.normal,
            ),
            dropdownColor: highContrast ? Colors.yellow.shade700 : Colors.white, // Colore menu
            iconEnabledColor: highContrast ? Colors.black : Colors.grey.shade800, // Colore icona freccia
            // Genera le opzioni del menu a discesa
            items: options
                .map(
                  (opt) => DropdownMenuItem<String>(
                    value: opt,
                    child: Semantics(
                      label: opt,
                      selected: value == opt,
                      child: Text(opt),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged, // Callback quando cambia la selezione
          ),
        ),
      ),
    );
  }
}
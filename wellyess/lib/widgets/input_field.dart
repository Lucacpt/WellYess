import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

// InputField è un campo di testo personalizzato che si adatta alle impostazioni di accessibilità
class InputField extends StatelessWidget {
  final TextEditingController controller; // Controller per gestire il testo inserito
  final String placeholder;               // Testo segnaposto da mostrare quando il campo è vuoto
  final int maxLines;                     // Numero massimo di righe (default 1)
  final ValueChanged<String>? onChanged;  // Callback chiamata quando il testo cambia

  const InputField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Recupera impostazioni di accessibilità dal provider
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    // Colori adattati per l'accessibilità
    final Color bgColor = highContrast ? Colors.yellow.shade700 : Colors.white;
    final Color textColor = highContrast ? Colors.black : Colors.black87;
    final Color hintColor = highContrast ? Colors.black54 : Colors.grey;

    return Semantics(
      label: placeholder, // Etichetta per screen reader
      hint: 'Campo di testo. Inserisci il testo richiesto.', // Suggerimento per accessibilità
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
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        child: TextField(
          controller: controller,     // Controller per il testo
          maxLines: maxLines,         // Numero massimo di righe
          onChanged: onChanged,       // Callback al cambio testo
          decoration: InputDecoration(
            hintText: placeholder,    // Testo segnaposto
            hintStyle: TextStyle(
              color: hintColor,
              fontSize: (screenWidth * 0.04 * fontSizeFactor).clamp(14.0, 22.0),
              fontWeight: highContrast ? FontWeight.bold : FontWeight.normal,
            ),
            border: InputBorder.none, // Nessun bordo standard
          ),
          style: TextStyle(
            fontSize: (screenWidth * 0.04 * fontSizeFactor).clamp(14.0, 22.0), // Font adattato
            color: textColor,
            fontWeight: highContrast ? FontWeight.bold : FontWeight.normal,
          ),
          cursorColor: textColor, // Colore del cursore
        ),
      ),
    );
  }
}
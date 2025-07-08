import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

// InfoRow è un widget che mostra una riga con etichetta e valore, adattata per l'accessibilità
class InfoRow extends StatelessWidget {
  final String label; // Etichetta descrittiva (es: "Nome")
  final String value; // Valore da mostrare (es: "Mario Rossi")

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Recupera impostazioni di accessibilità dal provider
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Etichetta in grassetto
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.06 * fontSizeFactor, // Font adattato per accessibilità
            color: highContrast ? Colors.black : Colors.black,
          ),
          textAlign: TextAlign.left,
        ),
        // Valore associato all'etichetta
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth * 0.06 * fontSizeFactor, // Font adattato per accessibilità
            color: highContrast ? Colors.black : Colors.black,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}
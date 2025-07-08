import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

// LegendaPallino è un widget che mostra una legenda con un pallino colorato e una descrizione testuale
class LegendaPallino extends StatelessWidget {
  final String text;   // Testo descrittivo della legenda (es: "Assunto")
  final Color color;   // Colore del pallino

  const LegendaPallino({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    // Limita la crescita del font per evitare overflow
    final double fontSize = (screenWidth * 0.038 * fontSizeFactor)
        .clamp(12.0, 16.0);

    return Row(
      children: [
        // Pallino colorato che rappresenta lo stato
        CircleAvatar(
          radius: (screenWidth * 0.02).clamp(8.0, 12.0), // Limite per non farlo esplodere
          backgroundColor: color,
          // Bordo nero in highContrast per maggiore visibilità
          child: highContrast
              ? Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                )
              : null,
        ),
        // Spazio tra pallino e testo
        SizedBox(width: (screenWidth * 0.015).clamp(4.0, 10.0)),
        // Testo descrittivo della legenda
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: highContrast ? Colors.black : Colors.black87,
            fontWeight:
                highContrast ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
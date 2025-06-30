import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class LegendaPallino extends StatelessWidget {
  final String text;
  final Color color;

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
        SizedBox(width: (screenWidth * 0.015).clamp(4.0, 10.0)),
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
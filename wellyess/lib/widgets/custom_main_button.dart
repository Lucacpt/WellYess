import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

// Pulsante principale personalizzato che si adatta alle impostazioni di accessibilità
class CustomMainButton extends StatelessWidget {
  final String text;         // Testo da mostrare sul pulsante
  final Color color;         // Colore di sfondo del pulsante
  final VoidCallback onTap;  // Callback quando il pulsante viene premuto
  final IconData? icon;      // Icona opzionale da mostrare accanto al testo

  const CustomMainButton({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Recupera impostazioni di accessibilità dal provider
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calcola la dimensione del font e dell'icona in modo responsivo e accessibile
    final double responsiveFontSize = (screenWidth * 0.05 * fontSizeFactor).clamp(16.0, 24.0);
    final double responsiveIconSize = responsiveFontSize * 1.1;

    // Stile del pulsante adattato per accessibilità e contrasto
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: highContrast ? Colors.yellow.shade700 : color, // Sfondo
      foregroundColor: highContrast ? Colors.black : Colors.white,    // Colore testo/icona
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),  // Padding verticale
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Bordo arrotondato
        side: highContrast
            ? const BorderSide(color: Colors.black, width: 2)
            : BorderSide.none,
      ),
      elevation: 3,
      textStyle: TextStyle(
        fontSize: responsiveFontSize,
        fontWeight: FontWeight.w600,
      ),
    );

    // Stile del testo adattato per accessibilità
    final textStyle = TextStyle(
      color: highContrast ? Colors.black : Colors.white,
      fontSize: responsiveFontSize,
      fontWeight: FontWeight.w600,
    );

    return SizedBox(
      width: double.infinity, // Occupa tutta la larghezza disponibile
      child: icon != null
          // Se è presente un'icona, usa ElevatedButton.icon
          ? ElevatedButton.icon(
              style: buttonStyle,
              onPressed: onTap,
              icon: Icon(
                icon,
                size: responsiveIconSize,
                color: highContrast ? Colors.black : Colors.white,
              ),
              label: Text(text, style: textStyle),
            )
          // Altrimenti solo testo
          : ElevatedButton(
              style: buttonStyle,
              onPressed: onTap,
              child: Text(text, style: textStyle),
            ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

// Pulsante personalizzato che si adatta alle impostazioni di accessibilità
class CustomButton extends StatelessWidget {
  final String text;           // Testo da mostrare sul pulsante
  final VoidCallback onPressed; // Callback quando il pulsante viene premuto
  final Color? color;           // Colore di sfondo opzionale
  final double? fontSize;       // Dimensione font opzionale
  final IconData? icon;         // Icona opzionale da mostrare accanto al testo

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.fontSize,
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

    // Calcola la dimensione del font in modo responsivo e accessibile
    final double responsiveFontSize = (fontSize ?? screenWidth * 0.04) *
        fontSizeFactor;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // Colore di sfondo adattato per alto contrasto o colore personalizzato
        backgroundColor: highContrast
            ? (color ?? Colors.yellow.shade700)
            : (color ?? const Color(0xFF5DB47F)),
        // Colore del testo/icone adattato per alto contrasto
        foregroundColor: highContrast ? Colors.black : Colors.white,
        // Padding interno del pulsante
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenHeight * 0.01,
        ),
        // Bordo arrotondato e bordo nero se alto contrasto
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.02),
          side: highContrast
              ? const BorderSide(color: Colors.black, width: 2)
              : BorderSide.none,
        ),
        elevation: 2,
        textStyle: TextStyle(fontSize: responsiveFontSize),
      ),
      onPressed: onPressed,
      // Se è presente un'icona, mostra testo e icona in riga, altrimenti solo testo
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: TextStyle(fontSize: responsiveFontSize),
                ),
                SizedBox(width: screenWidth * 0.02),
                Icon(
                  icon,
                  size: responsiveFontSize * 1.1,
                  color: highContrast ? Colors.black : Colors.white,
                ),
              ],
            )
          : Text(
              text,
              style: TextStyle(fontSize: responsiveFontSize),
              textAlign: TextAlign.center,
            ),
    );
  }
}
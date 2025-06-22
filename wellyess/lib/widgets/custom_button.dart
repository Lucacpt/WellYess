import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double? fontSize;
  final IconData? icon; // <- parametro opzionale per l'icona

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
    // MODIFICATO: Aggiunto MediaQuery per dimensioni responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // MODIFICATO: Dimensione del font di default resa responsive
    final double responsiveFontSize = fontSize ?? screenWidth * 0.04;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? const Color(0xFF5DB47F),
        foregroundColor: Colors.white,
        // MODIFICATO: Padding reso responsive per un aspetto migliore
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenHeight * 0.01,
        ),
        // MODIFICATO: Bordo reso responsive
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.02)),
        elevation: 2,
      ),
      onPressed: onPressed,
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  text,
                  style: TextStyle(fontSize: responsiveFontSize),
                ),
                // MODIFICATO: Spaziatura resa responsive
                SizedBox(width: screenWidth * 0.02),
                // MODIFICATO: Dimensione icona resa responsive
                Icon(icon, size: responsiveFontSize * 1.1),
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
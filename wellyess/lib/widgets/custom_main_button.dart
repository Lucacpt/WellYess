import 'package:flutter/material.dart';

class CustomMainButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;
  // MODIFICA: Aggiunto il campo opzionale per l'icona
  final IconData? icon;

  const CustomMainButton({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
    this.icon, // Icona opzionale
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 3,
    );

    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: screenWidth * 0.05,
      fontWeight: FontWeight.w600,
    );

    return SizedBox(
      width: double.infinity,
      // MODIFICA: Logica per mostrare il pulsante con o senza icona
      child: icon != null
          ? ElevatedButton.icon(
              style: buttonStyle,
              onPressed: onTap,
              icon: Icon(icon, color: Colors.white),
              label: Text(text, style: textStyle),
            )
          : ElevatedButton(
              style: buttonStyle,
              onPressed: onTap,
              child: Text(text, style: textStyle),
            ),
    );
  }
}
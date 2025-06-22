import 'package:flutter/material.dart';

class CustomMainButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const CustomMainButton({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: double.infinity, // prende tutta la larghezza disponibile
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          // Padding verticale aumentato per un pulsante più alto
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.022),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 3,
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            // Dimensione del font aumentata
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
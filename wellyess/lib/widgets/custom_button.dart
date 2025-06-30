import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double? fontSize;
  final IconData? icon; // parametro opzionale per l'icona

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
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double responsiveFontSize = (fontSize ?? screenWidth * 0.04) *
        fontSizeFactor;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: highContrast
            ? (color ?? Colors.yellow.shade700)
            : (color ?? const Color(0xFF5DB47F)),
        foregroundColor: highContrast ? Colors.black : Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenHeight * 0.01,
        ),
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class CustomMainButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;
  final IconData? icon;

  const CustomMainButton({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double responsiveFontSize = (screenWidth * 0.05 * fontSizeFactor).clamp(16.0, 24.0);
    final double responsiveIconSize = responsiveFontSize * 1.1;

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: highContrast ? Colors.yellow.shade700 : color,
      foregroundColor: highContrast ? Colors.black : Colors.white,
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: highContrast ? const BorderSide(color: Colors.black, width: 2) : BorderSide.none,
      ),
      elevation: 3,
      textStyle: TextStyle(
        fontSize: responsiveFontSize,
        fontWeight: FontWeight.w600,
      ),
    );

    final textStyle = TextStyle(
      color: highContrast ? Colors.black : Colors.white,
      fontSize: responsiveFontSize,
      fontWeight: FontWeight.w600,
    );

    return SizedBox(
      width: double.infinity,
      child: icon != null
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
          : ElevatedButton(
              style: buttonStyle,
              onPressed: onTap,
              child: Text(text, style: textStyle),
            ),
    );
  }
}
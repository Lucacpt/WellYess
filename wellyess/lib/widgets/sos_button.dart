import 'package:flutter/material.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class SosButton extends StatelessWidget {
  final VoidCallback onPressed;
  final UserType userType;
  final bool hasNewRequest;

  const SosButton({
    super.key,
    required this.onPressed,
    required this.userType,
    this.hasNewRequest = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    // Colori accessibili
    final Color buttonColor = highContrast ? Colors.black : const Color(0xFFF44336);
    final Color textColor = highContrast ? Colors.yellow.shade700 : Colors.white;
    final Color borderColor = highContrast ? Colors.yellow.shade700 : Colors.white;
    final Color badgeColor = highContrast ? Colors.yellow.shade700 : Colors.red.shade700;
    final Color badgeBorder = highContrast ? Colors.black : Colors.white;

    // Stile di base del pulsante
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: buttonColor,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.08,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        side: highContrast ? BorderSide(color: borderColor, width: 2) : BorderSide.none,
      ),
      elevation: 4,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    // Stile di base del testo
    final textStyle = TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
    );

    if (userType == UserType.caregiver) {
      // --- VISTA PER IL CAREGIVER ---
      return Stack(
        clipBehavior: Clip.none,
        children: [
          ElevatedButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: Center(
              child: Text(
                "Gestione SOS",
                style: textStyle.copyWith(
                  fontSize: (screenWidth * 0.055 * fontSizeFactor).clamp(16.0, 24.0),
                ),
              ),
            ),
          ),
          if (hasNewRequest)
            Positioned(
              top: -14, // più visibile e centrato
              right: 2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: highContrast ? Colors.yellow.shade700 : Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: highContrast ? Colors.black : Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                constraints: const BoxConstraints(
                  minWidth: 28,
                  minHeight: 28,
                ),
                child: Icon(
                  Icons.priority_high,
                  color: highContrast ? Colors.black : Colors.white,
                  size: 18,
                  semanticLabel: "Nuova emergenza SOS",
                ),
              ),
            ),
        ],
      );
    } else {
      // --- VISTA PER L'ANZIANO ---
      return ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Center(
          child: Text(
            "SOS",
            style: textStyle.copyWith(
              fontSize: (screenWidth * 0.1 * fontSizeFactor).clamp(24.0, 32.0),
              letterSpacing: 2,
            ),
          ),
        ),
      );
    }
  }
}
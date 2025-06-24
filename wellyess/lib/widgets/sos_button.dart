import 'package:flutter/material.dart';
// MODIFICA: Aggiunto import per il modello utente
import 'package:wellyess/models/user_model.dart';

/*
  SosButton è un widget riutilizzabile per il pulsante SOS
  Campi:
    - onPressed: callback che viene chiamata quando il pulsante viene premuto
    - userType: il tipo di utente (anziano o caregiver)
    - hasNewRequest: (solo per caregiver) indica se ci sono nuove richieste
*/
class SosButton extends StatelessWidget {
  final VoidCallback onPressed;
  // MODIFICA: Aggiunti campi per gestire la logica utente
  final UserType userType;
  final bool hasNewRequest;

  const SosButton({
    super.key,
    required this.onPressed,
    required this.userType,
    this.hasNewRequest = false, // Di default non ci sono nuove richieste
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Stile di base del pulsante
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFF44336),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.08,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
      ),
      elevation: 4,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );

    // Stile di base del testo
    final textStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
    );

    // --- MODIFICA: Logica per differenziare la vista ---
    if (userType == UserType.caregiver) {
      // --- VISTA PER IL CAREGIVER ---
      return Stack(
        clipBehavior: Clip.none, // Permette al pallino di uscire dai bordi
        children: [
          ElevatedButton(
            onPressed: onPressed,
            style: buttonStyle,
            child: Center(
              child: Text(
                "Gestione SOS",
                style: textStyle.copyWith(fontSize: screenWidth * 0.055),
              ),
            ),
          ),
          // Mostra il pallino di notifica solo se ci sono nuove richieste
          if (hasNewRequest)
            Positioned(
              top: -5,
              right: -5,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
              ),
            ),
        ],
      );
    } else {
      // --- VISTA PER L'ANZIANO (originale) ---
      return ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Center(
          child: Text(
            "SOS",
            style: textStyle.copyWith(
              fontSize: screenWidth * 0.1,
              letterSpacing: 2,
            ),
          ),
        ),
      );
    }
  }
}
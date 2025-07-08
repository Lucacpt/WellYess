import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import 'package:wellyess/widgets/tappable_reader.dart';
import 'package:wellyess/services/flutter_tts.dart';

/*
  BackCircleButton è un widget riutilizzabile per un bottone circolare che torna indietro
  Campi:
    - onPressed: callback opzionale che viene chiamata quando il bottone viene premuto
*/
class BackCircleButton extends StatelessWidget {
  // Callback quando si preme il bottone
  final VoidCallback? onPressed;

  // Costruttore del BackCircleButton che accetta un callback opzionale onPressed
  const BackCircleButton({super.key, this.onPressed});

  // Il metodo build costruisce l'interfaccia utente del widget
  @override
  Widget build(BuildContext context) {
    // Recupera impostazioni di accessibilità dal provider
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    final screenWidth = MediaQuery.of(context).size.width;
    // Calcola la dimensione del bottone e dell'icona in modo responsivo e accessibile
    final double buttonSize = screenWidth * 0.09 * fontSizeFactor;
    final double iconSize = buttonSize * 0.6;

    return Semantics(
      button: true,
      label: 'Torna indietro', // Etichetta per screen reader
      hint: 'Torna alla schermata precedente', // Suggerimento per accessibilità
      child: TappableReader(
        label: 'Torna indietro', // Etichetta per lettura vocale
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            // Se TalkBack è attivo, annuncia il bottone
            if (access.talkbackEnabled) {
              TalkbackService.announce('Torna indietro');
            }
            onPressed?.call(); // Esegue la callback se presente
          },
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: highContrast ? Colors.yellow.shade700 : const Color(0xFF5DB47F), // Sfondo adattato per contrasto
              shape: BoxShape.circle,
              border: highContrast
                  ? Border.all(color: Colors.black, width: 2) // Bordo nero se alto contrasto
                  : null,
            ),
            child: Icon(
              Icons.arrow_back,
              color: highContrast ? Colors.black : Colors.white, // Colore icona adattato per contrasto
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
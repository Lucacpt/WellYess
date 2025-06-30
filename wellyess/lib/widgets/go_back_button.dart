import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

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
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    final screenWidth = MediaQuery.of(context).size.width;
    final double buttonSize = screenWidth * 0.09 * fontSizeFactor;
    final double iconSize = buttonSize * 0.6;

    return Semantics(
      button: true,
      label: 'Torna indietro',
      hint: 'Torna alla schermata precedente',
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: highContrast ? Colors.yellow.shade700 : const Color(0xFF5DB47F),
            shape: BoxShape.circle,
            border: highContrast
                ? Border.all(color: Colors.black, width: 2)
                : null,
          ),
          child: Icon(
            Icons.arrow_back,
            color: highContrast ? Colors.black : Colors.white,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}

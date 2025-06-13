import 'package:flutter/material.dart';

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
    // Se onPressed è null, non fa nulla quando si preme il bottone
    return GestureDetector(
      onTap: onPressed,   // Chiama la funzione onPressed quando si preme il bottone
      // Contenitore che rappresenta il bottone circolare
      child: Container(
        width: 35,
        height: 35,
        // Forma circolare del bottone
        decoration: const BoxDecoration(
          color: Color(0xFF5DB47F), // verde
          // Bordi arrotondati per creare un cerchio
          shape: BoxShape.circle,
        ),
        // Icona all'interno del bottone
        child: const Icon(
          // Icona di freccia indietro
          Icons.arrow_back,
          // Colore dell'icona
          color: Colors.white,
        ),
      ),
    );
  }
}

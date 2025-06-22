import 'package:flutter/material.dart';

/*
  SosButton è un widget riutilizzabile per il pulsante SOS
  Campi:
    - onPressed: callback che viene chiamata quando il pulsante viene premuto
*/
class SosButton extends StatelessWidget {
  // Callback che viene chiamata quando il pulsante viene premuto
  final VoidCallback onPressed;

  // Costruttore del SosButton che richiede un callback onPressed
  const SosButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF44336), // Rosso standard di Material, fedele all'immagine
        // MODIFICA CHIAVE: Rimosso il padding verticale.
        // Questo permette al widget 'Center' di posizionare il testo
        // perfettamente al centro dello spazio verticale disponibile.
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.08,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
        ),
        elevation: 4,
        // Aggiunto per rimuovere il padding minimo di default del pulsante,
        // dando al Center il pieno controllo.
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      // Il widget Center ora centra il testo nello spazio totale del pulsante.
      child: Center(
        child: Text(
          "SOS",
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.1, // Dimensione più bilanciata
            fontWeight: FontWeight.bold,
            letterSpacing: 2, // Aggiunge spazio tra le lettere per leggibilità
          ),
        ),
      ),
    );
  }
}
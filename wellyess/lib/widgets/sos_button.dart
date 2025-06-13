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
  // Il parametro super.key è opzionale e può essere utilizzato per identificare univocamente il widget
  const SosButton({super.key, required this.onPressed});

  // Il metodo build costruisce l'interfaccia utente del widget
  @override
  Widget build(BuildContext context) {
    // Restituisce un ElevatedButton con uno stile personalizzato
    return ElevatedButton(
      onPressed: onPressed, // Gestisce il tap sul pulsante
      // Stile del pulsante
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        // Padding interno del pulsante
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        // Forma del pulsante con bordi arrotondati
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        // Colore dell'ombra del pulsante
        elevation: 4,
      ),
      // Testo del pulsante
      child: const Text(
        "SOS",
        style: TextStyle(
          color: Colors.white,
          fontSize: 50,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

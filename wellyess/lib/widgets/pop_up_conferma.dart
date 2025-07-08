import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import 'package:wellyess/widgets/tappable_reader.dart';
import 'package:wellyess/services/flutter_tts.dart';

// PopUpConferma è un dialog di conferma/informazione con un solo pulsante di chiusura
class PopUpConferma extends StatelessWidget {
  final String message;           // Messaggio da mostrare nel popup
  final VoidCallback? onConfirm;  // Callback opzionale da eseguire alla conferma/chiusura

  const PopUpConferma({
    Key? key,
    required this.message,
    this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Recupera impostazioni di accessibilità dal provider
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    // Colori adattati per l'accessibilità e il contrasto
    final Color bgColor = highContrast ? Colors.black : Colors.white;
    final Color borderColor = highContrast ? Colors.yellow : Colors.transparent;
    final Color textColor = highContrast ? Colors.yellow : Colors.black87;
    final Color buttonBg = highContrast ? Colors.black : Colors.redAccent;
    final Color iconColor = highContrast ? Colors.yellow : Colors.white;

    return AlertDialog(
      backgroundColor: bgColor, // Sfondo del popup
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24), // Bordo arrotondato
        side: BorderSide(color: borderColor, width: highContrast ? 3 : 0), // Bordo visibile in alto contrasto
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      // Messaggio centrale, letto anche da screen reader
      content: TappableReader(
        label: message,
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: (18 * fontSizeFactor).clamp(15.0, 24.0),
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        // Pulsante circolare per chiudere il popup
        TappableReader(
          label: 'Chiudi conferma',
          child: ElevatedButton(
            onPressed: () {
              TalkbackService.announce(message); // Annuncia il messaggio se TalkBack è attivo
              Navigator.of(context).pop();       // Chiude il popup
              if (onConfirm != null) onConfirm!(); // Esegue la callback se presente
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonBg, // Colore di sfondo del bottone
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(16),
              elevation: 6,
              side: highContrast
                  ? const BorderSide(color: Colors.yellow, width: 2)
                  : BorderSide.none,
            ),
            child: Icon(Icons.close, color: iconColor, size: 28), // Icona di chiusura
          ),
        ),
      ],
    );
  }
}
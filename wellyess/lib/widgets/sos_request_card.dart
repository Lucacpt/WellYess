import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/screens/sos_details_screen.dart';
import 'package:wellyess/models/accessibilita_model.dart';

// SosRequestCard mostra una card per una richiesta SOS, evidenziata se nuova
class SosRequestCard extends StatelessWidget {
  final String personName;   // Nome della persona che ha inviato la richiesta SOS
  final String timestamp;    // Data e ora della richiesta
  final bool isNew;          // True se la richiesta è nuova e non ancora gestita

  const SosRequestCard({
    super.key,
    required this.personName,
    required this.timestamp,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    // Colore di sfondo della card
    final Color cardColor = Colors.white;
    // Bordo rosso se nuova, nero se alto contrasto, trasparente altrimenti
    final Color borderColor = highContrast
        ? Colors.black
        : (isNew ? Colors.red.shade300 : Colors.transparent);
    final double borderWidth = highContrast ? 2.0 : (isNew ? 2.0 : 0.0);

    // Colore icona: rosso se nuova, verde se gestita, adattato per contrasto
    final Color iconColor = isNew
        ? (highContrast ? Colors.red.shade800 : Colors.red.shade700)
        : (highContrast ? Colors.green.shade800 : Colors.green);
    final Color personTextColor = highContrast ? Colors.black : Colors.black87;
    final Color timestampColor = highContrast ? Colors.black : Colors.grey.shade600;
    final Color arrowColor = highContrast ? Colors.black : Colors.grey.shade600;
    final Color gestitaColor = highContrast ? Colors.green.shade800 : Colors.green;

    return Card(
      color: cardColor,
      elevation: 5, // Ombra della card
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Bordo arrotondato
        side: BorderSide(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: InkWell(
        // Se la richiesta è nuova, permette il tap per vedere i dettagli
        onTap: isNew
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SosDetailsScreen(),
                  ),
                );
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icona di stato: warning se nuova, check se gestita
              Icon(
                isNew ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                color: iconColor,
                size: (screenWidth * 0.1).clamp(28.0, 44.0),
              ),
              const SizedBox(width: 16),
              // Nome persona e timestamp
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome della persona
                    Text(
                      personName,
                      style: TextStyle(
                        fontSize: (screenWidth * 0.045 * fontSizeFactor).clamp(14.0, 25.0),
                        fontWeight: FontWeight.bold,
                        color: personTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Data e ora della richiesta
                    Text(
                      timestamp,
                      style: TextStyle(
                        fontSize: (screenWidth * 0.038 * fontSizeFactor).clamp(12.0, 20.0),
                        color: timestampColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Se nuova mostra freccia, se gestita mostra testo "Gestita"
              if (isNew)
                Icon(
                  Icons.arrow_forward_ios,
                  color: arrowColor,
                  size: (screenWidth * 0.05).clamp(14.0, 22.0),
                )
              else
                Text(
                  'Gestita',
                  style: TextStyle(
                    color: gestitaColor,
                    fontWeight: FontWeight.bold,
                    fontSize: (screenWidth * 0.038 * fontSizeFactor).clamp(12.0, 20.0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
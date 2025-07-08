import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

// Widget che rappresenta una card per una funzionalità principale dell'app
class FeatureCard extends StatelessWidget {
  final Widget icon;           // Icona da mostrare nella card
  final String label;          // Etichetta descrittiva della funzionalità
  final VoidCallback? onTap;   // Callback quando la card viene premuta

  const FeatureCard({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Recupera impostazioni di accessibilità dal provider
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    return Card(
      // Colore di sfondo adattato per alto contrasto
      color: highContrast ? Colors.yellow.shade700 : Colors.white,
      elevation: 5, // Ombra della card
      shadowColor: Colors.grey.shade500,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Bordo arrotondato
        side: highContrast
            ? const BorderSide(color: Colors.black, width: 2) // Bordo nero se alto contrasto
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap, // Gestisce il tap sulla card
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.03), // Padding interno
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                icon, // Icona della funzionalità
                SizedBox(height: screenWidth * 0.02),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label, // Etichetta della funzionalità
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.055 * fontSizeFactor, // Font adattato per accessibilità
                        fontWeight: FontWeight.bold,
                        color: highContrast ? Colors.black : Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis, // Tronca il testo se troppo lungo
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
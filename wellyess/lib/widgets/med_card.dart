import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

// Widget per la card del farmaco come da immagine
class FarmacoCard extends StatelessWidget {
  final Color statoColore;      // Colore che indica lo stato del farmaco (es: verde, rosso, grigio)
  final String orario;          // Orario di assunzione del farmaco
  final String nome;            // Nome del farmaco
  final String? dose;           // Dose del farmaco (opzionale)
  final VoidCallback? onTap;    // Callback quando la card viene premuta (opzionale)
  final bool isHighlighted;     // Se true, la card viene evidenziata (bordo blu)

  const FarmacoCard({
    Key? key,
    required this.statoColore,
    required this.orario,
    required this.nome,
    this.dose,
    this.onTap,
    this.isHighlighted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final access = Provider.of<AccessibilitaModel>(context);
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    final Color cardColor = Colors.white; // Colore di sfondo della card
    final Color textColor = highContrast ? Colors.black : Colors.black87; // Colore testo adattato per contrasto
    final Color iconColor = highContrast ? Colors.black : Colors.grey;    // Colore icona adattato per contrasto

    // Bordo nero sempre visibile in highContrast, blu se evidenziato
    final BorderSide borderSide = highContrast
        ? const BorderSide(color: Colors.black, width: 2)
        : (isHighlighted
            ? const BorderSide(color: Colors.blue, width: 3)
            : BorderSide.none);

    return Semantics(
      button: onTap != null, // Indica che la card è un bottone se onTap è presente
      label: '$nome, orario $orario, ' +
          (statoColore == Colors.green
              ? 'assunto'
              : statoColore == Colors.red
                  ? 'saltato'
                  : 'in attesa'), // Descrizione per screen reader
      hint: onTap != null ? 'Tocca per cambiare stato' : null, // Suggerimento per accessibilità
      child: GestureDetector(
        onTap: onTap, // Gestisce il tap sulla card
        child: Card(
          color: cardColor,
          elevation: 4, // Ombra della card
          margin: EdgeInsets.symmetric(
              vertical: screenWidth * 0.015),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Bordo arrotondato
            side: borderSide, // Bordo adattato per contrasto/evidenziazione
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Barra colorata verticale che indica lo stato del farmaco
                Container(
                  width: screenWidth * 0.06,
                  decoration: BoxDecoration(
                    color: statoColore,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                ),
                // Contenuto principale della card
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenWidth * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Orario di assunzione
                        Text(
                          orario,
                          style: TextStyle(
                            fontSize: (screenWidth * 0.06 * fontSizeFactor).clamp(14.0, 22.0),
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        // Nome e dose del farmaco (se presente)
                        Expanded(
                          child: Text(
                            dose != null
                                ? '$nome $dose'
                                : nome, // Mostra solo il nome se la dose è nulla
                            style: TextStyle(
                              fontSize: (screenWidth * 0.06 * fontSizeFactor).clamp(14.0, 22.0),
                              color: textColor,
                            ),
                            overflow: TextOverflow.ellipsis, // Tronca se troppo lungo
                          ),
                        ),
                        // Icona freccia se la card è tappabile
                        if (onTap != null)
                          Icon(
                            Icons.chevron_right,
                            color: iconColor,
                            size: (screenWidth * 0.06 * fontSizeFactor).clamp(18.0, 28.0),
                          ),
                      ],
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
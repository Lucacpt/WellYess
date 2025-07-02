import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

// Widget per la card del farmaco come da immagine
class FarmacoCard extends StatelessWidget {
  final Color statoColore;
  final String orario;
  final String nome;
  final String? dose;
  final VoidCallback? onTap;
  final bool isHighlighted;

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

    final Color cardColor = Colors.white;
    final Color textColor = highContrast ? Colors.black : Colors.black87;
    final Color iconColor = highContrast ? Colors.black : Colors.grey;

    // Bordo nero sempre visibile in highContrast, blu se evidenziato
    final BorderSide borderSide = highContrast
        ? const BorderSide(color: Colors.black, width: 2)
        : (isHighlighted
            ? const BorderSide(color: Colors.blue, width: 3)
            : BorderSide.none);

    return Semantics(
      button: onTap != null,
      label: '$nome, orario $orario, ' +
          (statoColore == Colors.green
              ? 'assunto'
              : statoColore == Colors.red
                  ? 'saltato'
                  : 'in attesa'),
      hint: onTap != null ? 'Tocca per cambiare stato' : null,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: cardColor,
          elevation: 4,
          margin: EdgeInsets.symmetric(
              vertical: screenWidth * 0.015),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: borderSide,
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Barra colorata
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
                // Contenuto
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenWidth * 0.03),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          orario,
                          style: TextStyle(
                            fontSize: (screenWidth * 0.06 * fontSizeFactor).clamp(14.0, 22.0),
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: Text(
                            dose != null
                                ? '$nome $dose'
                                : nome, // Mostra solo il nome se la dose è nulla
                            style: TextStyle(
                              fontSize: (screenWidth * 0.06 * fontSizeFactor).clamp(14.0, 22.0),
                              color: textColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
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
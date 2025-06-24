import 'package:flutter/material.dart';

// Widget per la card del farmaco come da immagine
class FarmacoCard extends StatelessWidget {
  final Color statoColore;
  final String orario;
  final String nome;
  final String dose;
  final VoidCallback? onTap;

  const FarmacoCard({
    Key? key,
    required this.statoColore,
    required this.orario,
    required this.nome,
    required this.dose,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 4,
        margin: EdgeInsets.symmetric(
            vertical: screenWidth * 0.015), // Reso responsivo (era 6)
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15)), // Il valore fisso qui è ok
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Barra colorata
              Container(
                width: screenWidth * 0.06, // Reso responsivo (era 25)
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
                      vertical: screenWidth * 0.03), // Reso responsivo
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        orario,
                        style: TextStyle(
                            fontSize: screenWidth * 0.04, // Reso responsivo (era 18)
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                          width: screenWidth * 0.03), // Reso responsivo (era 12)
                      Expanded(
                        child: Text(
                          '$nome $dose',
                          style: TextStyle(
                              fontSize:
                                  screenWidth * 0.04), // Reso responsivo (era 18)
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (onTap != null)
                        Icon(Icons.chevron_right,
                            color: Colors.grey,
                            size: screenWidth * 0.06), // Reso responsivo
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
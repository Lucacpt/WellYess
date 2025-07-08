import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wellyess/widgets/tappable_reader.dart';
import '../widgets/base_layout.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

// Pagina di dettaglio per un singolo consiglio di salute
class ConsiglioDetailPage extends StatelessWidget {
  final String title; // Titolo del consiglio
  final String subtitle; // Sottotitolo del consiglio
  final String svgAssetPath; // Percorso dell'icona SVG
  final String description; // Descrizione testuale del consiglio
  final List<Map<String, dynamic>> topics; // Lista di argomenti/approfondimenti

  const ConsiglioDetailPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.svgAssetPath,
    required this.description,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    // Ottieni dimensioni schermo per layout responsivo
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Accessibilità: recupera i valori dal provider
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    // Calcola dimensioni responsive per padding e testo
    final double horizontalPadding = screenWidth * 0.04;
    final double verticalPadding = screenHeight * 0.015;
    final double titleFontSize = (screenWidth * 0.075 * fontSizeFactor).clamp(20.0, 36.0);
    final double subtitleFontSize = (screenWidth * 0.045 * fontSizeFactor).clamp(14.0, 28.0);
    final double iconSize = (screenWidth * 0.18 * fontSizeFactor).clamp(40.0, 90.0);
    final double descriptionFontSize = (screenWidth * 0.042 * fontSizeFactor).clamp(13.0, 24.0);
    final double topicTitleFontSize = (screenWidth * 0.048 * fontSizeFactor).clamp(14.0, 26.0);
    final double topicTextFontSize = (screenWidth * 0.041 * fontSizeFactor).clamp(13.0, 22.0);

    return BaseLayout(
      pageTitle: title, // Mostra il titolo nella barra superiore
      onBackPressed: () => Navigator.of(context).pop(), // Azione per il tasto indietro
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Titolo del consiglio
            TappableReader(
              label: 'Titolo consiglio: $title',
              child: Text(
                title,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: highContrast ? Colors.black : Colors.green.shade900,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            // Linea divisoria
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            SizedBox(height: screenHeight * 0.01),
            // Contenuto scorrevole
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Icona SVG in un cerchio con ombra
                    TappableReader(
                      label: 'Icona consiglio',
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: highContrast ? Colors.yellow.shade100 : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.15),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: highContrast
                              ? Border.all(color: Colors.black, width: 2)
                              : null,
                        ),
                        padding: EdgeInsets.all(screenWidth * 0.06),
                        child: SvgPicture.asset(
                          svgAssetPath,
                          height: iconSize,
                          width: iconSize,
                          colorFilter: ColorFilter.mode(
                            highContrast ? Colors.black : Colors.green.shade700,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    // Sottotitolo del consiglio
                    TappableReader(
                      label: 'Sottotitolo consiglio: $subtitle',
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          fontWeight: FontWeight.bold,
                          color: highContrast ? Colors.black : Colors.green.shade900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    // Descrizione testuale del consiglio
                    TappableReader(
                      label: 'Descrizione consiglio: $description',
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: descriptionFontSize,
                          color: highContrast ? Colors.black : Colors.grey.shade800,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Argomenti/approfondimenti come card leggere, con elenco puntato se serve
                    ...topics.map((topic) => TappableReader(
                      label: 'Sezione ${topic['title']}',
                      child: Padding(
                        padding: EdgeInsets.only(bottom: screenHeight * 0.018),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                              color: highContrast ? Colors.black : Colors.green.shade100,
                              width: 1.5,
                            ),
                          ),
                          color: highContrast ? Colors.yellow.shade100 : Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.018,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Titolo della sezione/argomento
                                TappableReader(
                                  label: 'Titolo sezione: ${topic['title']}',
                                  child: Text(
                                    topic['title'] ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: topicTitleFontSize,
                                      color: highContrast ? Colors.black : Colors.green.shade700,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6),
                                // Se il testo è una lista, mostra elenco puntato
                                if (topic['text'] is List)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: List<Widget>.from(
                                      (topic['text'] as List).map((item) => Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("• ",
                                            style: TextStyle(
                                              fontSize: topicTextFontSize,
                                              color: highContrast ? Colors.black : Colors.green.shade700,
                                            ),
                                          ),
                                          Expanded(
                                            child: TappableReader(
                                              label: item.toString(),
                                              child: Text(
                                                item.toString(),
                                                style: TextStyle(
                                                  fontSize: topicTextFontSize,
                                                  color: highContrast ? Colors.black : Colors.grey.shade800,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                    ),
                                  )
                                // Altrimenti mostra solo il testo
                                else
                                  Text(
                                    topic['text']?.toString() ?? '',
                                    style: TextStyle(
                                      fontSize: topicTextFontSize,
                                      color: highContrast ? Colors.black : Colors.grey.shade800,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )),
                    SizedBox(height: screenHeight * 0.01),
                    // Icona informativa finale
                    TappableReader(
                      label: 'Icona informativa finale',
                      child: Icon(
                        Icons.info_outline,
                        color: highContrast ? Colors.black : Colors.green.shade700,
                        size: (screenWidth * 0.09 * fontSizeFactor).clamp(24.0, 40.0),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    // Testo di incoraggiamento finale
                    TappableReader(
                      label: 'Testo di incoraggiamento finale',
                      child: Text(
                        "Segui questo consiglio per migliorare il tuo benessere quotidiano!",
                        style: TextStyle(
                          fontSize: (screenWidth * 0.038 * fontSizeFactor).clamp(12.0, 20.0),
                          color: highContrast ? Colors.black : Colors.green.shade700,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
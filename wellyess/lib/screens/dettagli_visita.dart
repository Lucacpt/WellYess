import 'package:flutter/material.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/info_row.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import 'package:wellyess/widgets/tappable_reader.dart';

// Schermata che mostra i dettagli di una visita medica
class DettagliVisitaScreen extends StatelessWidget {
  final Map<String, String> appointment; // Dati della visita (tipo, luogo, data, ora, note)

  const DettagliVisitaScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    // Ottieni dimensioni schermo per layout responsivo
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Accessibilità: recupera i valori dal provider
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    return BaseLayout(
      pageTitle: 'Dettagli Visita', // Titolo della pagina nella barra superiore
      onBackPressed: () => Navigator.of(context).pop(), // Azione per il tasto indietro
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SEZIONE SUPERIORE FISSA ---
            SizedBox(height: screenHeight * 0.01),
            Center(
              child: TappableReader(
                label: 'Titolo pagina Dettagli Visita',
                child: Text(
                  'Dettagli Visita',
                  style: TextStyle(
                    fontSize: (screenWidth * 0.07 * fontSizeFactor).clamp(20.0, 32.0),
                    fontWeight: FontWeight.bold,
                    color: highContrast ? Colors.black : Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Divider(color: Colors.grey.shade300, thickness: 1),
            SizedBox(height: screenHeight * 0.02),

            // --- SEZIONE INFERIORE SCORREVOLE ---
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04)
                    .copyWith(bottom: screenHeight * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Tipo visita (es: "Visita Cardiologica")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: screenWidth * 0.03),
                        Flexible(
                          child: TappableReader(
                            label: 'Tipo visita: ${appointment['tipoVisita'] ?? ''}',
                            child: Text(
                              appointment['tipoVisita'] ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: (screenWidth * 0.075 * fontSizeFactor).clamp(18.0, 32.0),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                color: highContrast ? Colors.black : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Riga info: Luogo della visita
                    TappableReader(
                      label: 'Luogo: ${appointment['luogo'] ?? ''}',
                      child: InfoRow(
                        label: 'Luogo',
                        value: appointment['luogo'] ?? '',
                      ),
                    ),
                    const Divider(),
                    SizedBox(height: screenHeight * 0.02),
                    // Riga info: Data della visita
                    TappableReader(
                      label: 'Data: ${appointment['data'] ?? ''}',
                      child: InfoRow(
                        label: 'Data',
                        value: appointment['data'] ?? '',
                      ),
                    ),
                    const Divider(),
                    SizedBox(height: screenHeight * 0.02),
                    // Riga info: Orario della visita
                    TappableReader(
                      label: 'Orario: ${appointment['ora'] ?? ''}',
                      child: InfoRow(
                        label: 'Orario',
                        value: appointment['ora'] ?? '',
                      ),
                    ),
                    const Divider(),
                    SizedBox(height: screenHeight * 0.02),
                    // Riga info: Note aggiuntive
                    TappableReader(
                      label: 'Note: ${appointment['note'] ?? ''}',
                      child: InfoRow(
                        label: 'Note',
                        value: appointment['note'] ?? '',
                      ),
                    ),
                    const Divider(),
                    SizedBox(height: screenHeight * 0.03),
                    // Titolo sezione mappa
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TappableReader(
                        label: 'Titolo sezione mappa: Posizione Luogo Della Visita',
                        child: Text(
                          'Posizione Luogo Della Visita',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: (screenWidth * 0.045 * fontSizeFactor).clamp(22.0, 28.0),
                            color: highContrast ? Colors.black : Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    // Immagine della mappa (statica)
                    TappableReader(
                      label: 'Mappa posizione della visita',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(screenWidth * 0.04),
                        child: Image.asset(
                          'assets/images/map.png',
                          height: screenHeight * 0.18,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
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
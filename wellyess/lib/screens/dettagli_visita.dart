import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/info_row.dart';

class DettagliVisitaScreen extends StatelessWidget {
  final Map<String, String> appointment;
  const DettagliVisitaScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BaseLayout(
      onBackPressed: () => Navigator.of(context).pop(),
      // MODIFICA: La struttura ora è una Column per separare la parte fissa da quella scorrevole.
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- SEZIONE SUPERIORE FISSA ---
            SizedBox(height: screenHeight * 0.01),
            Center(
              child: Text(
                'Dettagli Visita',
                style: TextStyle(
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Divider(color: Colors.grey.shade300, thickness: 1),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenWidth * 0.08,
                  width: screenWidth * 0.08,
                  child: SvgPicture.asset(
                    'assets/icons/med.svg',
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Flexible(
                  child: Text(
                    appointment['tipoVisita'] ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.075,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),

            // --- SEZIONE INFERIORE SCORREVOLE ---
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InfoRow(
                      label: 'Luogo',
                      value: appointment['luogo'] ?? '',
                    ),
                    const Divider(),
                    SizedBox(height: screenHeight * 0.02),
                    InfoRow(
                      label: 'Data',
                      value: appointment['data'] ?? '',
                    ),
                    const Divider(),
                    SizedBox(height: screenHeight * 0.02),
                    InfoRow(
                      label: 'Orario',
                      value: appointment['ora'] ?? '',
                    ),
                    const Divider(),
                    SizedBox(height: screenHeight * 0.02),
                    InfoRow(
                      label: 'Medico',
                      value: appointment['note'] ?? '', // Corretta la chiave
                    ),
                    const Divider(),
                    SizedBox(height: screenHeight * 0.03),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Posizione Luogo Della Visita',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(screenWidth * 0.04),
                      child: Image.asset(
                        'assets/images/map.png',
                        height: screenHeight * 0.18,
                        width: double.infinity,
                        fit: BoxFit.cover,
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
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
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    appointment['title'] ?? '',
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
            InfoRow(
              label: 'Luogo',
              value: appointment['location'] ?? '',
            ),
            const Divider(),
            SizedBox(height: screenHeight * 0.02),
            InfoRow(
              label: 'Data',
              value: appointment['date'] ?? '',
            ),
            const Divider(),
            SizedBox(height: screenHeight * 0.02),
            InfoRow(
              label: 'Orario',
              value: appointment['time'] ?? '',
            ),
            const Divider(),
            SizedBox(height: screenHeight * 0.02),
            InfoRow(
              label: 'Medico',
              value: appointment['doctor'] ?? '',
            ),
            const Divider(),
            SizedBox(height: screenHeight * 0.03),
            Text(
              'Posizione Luogo Della Visita',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.045,
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            ClipRRect(
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
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
    );
  }
}
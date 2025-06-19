import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/info_row.dart';

class DettagliVisitaScreen extends StatelessWidget {
  final Map<String, String> appointment;
  const DettagliVisitaScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.green.shade500;
    return BaseLayout(
      onBackPressed: () => Navigator.of(context).pop(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 2),
            const Center(
              child: Text(
                'Dettagli Visita',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade300),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SizedBox(
                    height: 28,
                    width: 28,
                    child: SvgPicture.asset(
                      'assets/icons/med.svg',
                    ),
                  ),
                ),
                Text(
                  appointment['title'] ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            InfoRow(
              label: 'Luogo',
              value: appointment['location'] ?? '',
              
            ),
            const Divider(),
            const SizedBox(height: 15),
            InfoRow(
              label: 'Data',
              value: appointment['date'] ?? '',
            ),
            const Divider(),
            const SizedBox(height: 15),
            InfoRow(
              label: 'Orario',
              value: appointment['time'] ?? '',
            ),
            const Divider(),
            const SizedBox(height: 15),
            InfoRow(
              label: 'Medico',
              value: appointment['doctor'] ?? '',
            ),
            const Divider(),
            const SizedBox(height: 15),
            const SizedBox(height: 18),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Posizione Luogo Della Visita',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/map.png',
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
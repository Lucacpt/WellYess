import 'package:flutter/material.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/custom_main_button.dart';
import 'package:wellyess/widgets/info_row.dart';

class DettagliFarmacoPage extends StatelessWidget {
  const DettagliFarmacoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      onBackPressed: () => Navigator.pop(context),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Titolo principale
            const Center(
              child: Text(
                'Dettagli farmaco',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(thickness: 1.2, height: 30),

            // Nome farmaco
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(width: 8),
                  Text(
                    'Aspirina',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Info dettagliate con InfoRow widget
            const InfoRow(label: 'Dose', value: '100 mg'),
            const Divider(),
            const SizedBox(height: 15),

            const InfoRow(label: 'Forma Terapeutica', value: 'Compressa'),
            const Divider(),
            const SizedBox(height: 15),

            const InfoRow(label: 'Orario', value: '08:00'),
            const Divider(),
            const SizedBox(height: 15),

            const InfoRow(label: 'Frequenza', value: '1 volta al giorno'),
            const Divider(),
            const SizedBox(height: 10),

            // Note in ExpansionTile per evidenziare contenuto espandibile
            ExpansionTile(
              title: const Center(
                child: Text(
                  'Note',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Da prendere a stomaco vuoto',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),

            const SizedBox(height: 30),

            // Pulsanti
            CustomMainButton(
              text: 'Modifica',
              color: const Color(0xFF5DB47F),
              onTap: () {
                // Naviga alla pagina di modifica
              },
            ),
            const SizedBox(height: 15),
            CustomMainButton(
              text: 'Elimina',
              color: const Color(0xFFED0606),
              onTap: () {
                // Conferma ed elimina
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

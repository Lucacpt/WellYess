import 'package:flutter/material.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/custom_button.dart';
import 'package:wellyess/widgets/med_details.dart';
import 'package:wellyess/widgets/med_state.dart';
import 'package:wellyess/widgets/med_legenda.dart';
import 'package:wellyess/widgets/custom_main_button.dart';
import 'med_details.dart';
import 'change_med_state.dart';

class FarmaciPage extends StatelessWidget {
  const FarmaciPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      onBackPressed: () => Navigator.pop(context),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text('Farmaci', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ),
            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Farmaci di oggi', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                CustomButton(
                  text: 'Modifica',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ModificaStatoFarmaciPage()),
                    );
                  },
                ),

              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                LegendaPallino(text: 'Assunto', color: Colors.green),
                LegendaPallino(text: 'In attesa', color: Colors.yellow),
                LegendaPallino(text: 'Saltato', color: Colors.red),
              ],
            ),
            const SizedBox(height: 10),

            const FarmacoGiornoCard(nome: 'Aspirina', dose: '100mg', orario: '08:00', statoColore: Colors.green),
            const FarmacoGiornoCard(nome: 'Lisinopril', dose: '10mg', orario: '12:00', statoColore: Colors.red),
            const FarmacoGiornoCard(nome: 'Coleros', dose: '20mg', orario: '18:00', statoColore: Colors.yellow),

            const Divider(),
            const SizedBox(height: 10),
            const Text('Tutti i farmaci', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),

            FarmacoDettagliCard(
              nome: 'Aspirina',
              dose: '100mg',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DettagliFarmacoPage(),
                  ),
                );
              },
            ),
            FarmacoDettagliCard(nome: 'Lisinopril', dose: '10mg', onPressed: () {}),
            FarmacoDettagliCard(nome: 'Coleros', dose: '20mg', onPressed: () {}),

            const SizedBox(height: 20),
            CustomMainButton(
              text: '+ Aggiungi Farmaco',
              color: const Color(0xFF5DB47F),
              onTap: () {
                // Logica per aggiungere farmaco
              },
            ),
          ],
        ),
      ),
    );
  }
}

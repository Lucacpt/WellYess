import 'package:flutter/material.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/custom_button.dart';
import 'package:wellyess/widgets/med_legenda.dart';
import 'package:wellyess/widgets/med_state.dart';

class ModificaStatoFarmaciPage extends StatelessWidget {
  const ModificaStatoFarmaciPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      onBackPressed: () => Navigator.pop(context),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: Text(
                'Modifica Stato\nFarmaci',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(thickness: 1.5, height: 40),

            const Text(
              'Farmaci Assunti Oggi',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                LegendaPallino(text: 'Assunto', color: Colors.green),
                LegendaPallino(text: 'Saltato', color: Colors.red),
              ],
            ),

            const SizedBox(height: 40),

            _farmacoItem(
              context,
              nome: 'Aspirina',
              statoColore: Colors.green,
            ),

            const SizedBox(height: 10),
            const Divider(thickness: 1.5, height: 40),
            const SizedBox(height: 10),

            _farmacoItem(
              context,
              nome: 'Ibuprofene',
              statoColore: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _farmacoItem(
    BuildContext context, {
    required String nome,
    String? dose,
    String? orario,
    required Color statoColore,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FarmacoGiornoCard(
          nome: nome,
          dose: dose ?? '',
          orario: orario ?? '',
          statoColore: statoColore,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                text: 'Assunto',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Farmaco "$nome" segnato come assunto')),
                  );
                },
                fontSize: 18,                
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomButton(
                text: 'Non preso',
                color: const Color(0xFFED0606),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Farmaco "$nome" segnato come non preso')),
                  );
                },
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

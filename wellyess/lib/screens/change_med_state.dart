import 'package:flutter/material.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/custom_main_button.dart';  // importa il CustomMainButton
import 'package:wellyess/widgets/confirm_popup.dart';       // importa il ConfirmDialog
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
        CustomMainButton(
          text: 'Modifica Stato Farmaco',
          color: Color(0xFF5DB47F),  // puoi cambiare il colore come preferisci
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) {
                return ConfirmDialog(
                  titleText: 'Hai assunto il farmaco $nome?',
                  cancelButtonText: 'No',
                  confirmButtonText: 'Sì',
                  onCancel: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Farmaco "$nome" segnato come NON assunto')),
                    );
                  },
                  onConfirm: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Farmaco "$nome" segnato come assunto')),
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}

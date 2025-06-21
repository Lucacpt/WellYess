import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/info_row.dart';
import 'package:wellyess/models/farmaco_model.dart';
import 'package:wellyess/widgets/custom_main_button.dart';
import 'package:wellyess/widgets/confirm_popup.dart';

class DettagliFarmacoPage extends StatelessWidget {
  final FarmacoModel farmaco;
  final dynamic farmacoKey;

  const DettagliFarmacoPage({
    Key? key,
    required this.farmaco,
    required this.farmacoKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      onBackPressed: () => Navigator.pop(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sezione superiore che si espande e scorre
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Text(
                        'Dettagli farmaco',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(thickness: 1.2, height: 30),
                    InfoRow(label: 'Nome', value: farmaco.nome),
                    const Divider(),
                    InfoRow(label: 'Dose', value: farmaco.dose),
                    const Divider(),
                    InfoRow(label: 'Forma', value: farmaco.formaTerapeutica),
                    const Divider(),
                    InfoRow(label: 'Orario', value: farmaco.orario),
                    const Divider(),
                    InfoRow(label: 'Frequenza', value: farmaco.frequenza),
                  ],
                ),
              ),
            ),

            // Pulsante fisso in basso
            const SizedBox(height: 20),
            CustomMainButton(
              text: 'Elimina',
              color: Colors.red.shade700,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return ConfirmDialog(
                      titleText:
                          'Vuoi davvero Eliminare?\nL’azione è irreversibile',
                      cancelButtonText: 'No, Esci',
                      confirmButtonText: 'Sì, Elimina',
                      onCancel: () {
                        Navigator.of(dialogContext).pop();
                      },
                      onConfirm: () {
                        // Logica di eliminazione dal database Hive
                        final box = Hive.box<FarmacoModel>('farmaci');
                        box.delete(farmacoKey);

                        Navigator.of(dialogContext).pop(); // Chiude il popup
                        Navigator.of(context).pop(); // Torna alla pagina precedente
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
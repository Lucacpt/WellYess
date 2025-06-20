import 'package:flutter/material.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/info_row.dart';
import 'package:wellyess/models/farmaco_model.dart';

class DettagliFarmacoPage extends StatelessWidget {
  final FarmacoModel farmaco;
  const DettagliFarmacoPage({
    Key? key,
    required this.farmaco,
  }) : super(key: key);

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
                'Dettagli farmaco',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
            const SizedBox(height: 20),
            // … eventuali bottoni Modifica/Elimina …
          ],
        ),
      ),
    );
  }
}

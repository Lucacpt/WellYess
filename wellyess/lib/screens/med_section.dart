import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wellyess/models/farmaco_model.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/med_state.dart';
import 'package:wellyess/screens/add_new_med.dart';
import 'package:wellyess/screens/med_details.dart'; // <-- import

class FarmaciPage extends StatelessWidget {
  const FarmaciPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<FarmacoModel>('farmaci');

    return BaseLayout(
      currentIndex: 1,
      onBackPressed: () => Navigator.of(context).pop(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titolo principale
            const Text(
              'Farmaci',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 24),

            // Sezione: Farmaci di Oggi
            const Text(
              'Farmaci di Oggi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _legendDot(Colors.green, 'Assunto'),
                const SizedBox(width: 16),
                _legendDot(Colors.orange, 'In attesa'),
                const SizedBox(width: 16),
                _legendDot(Colors.red, 'Saltato'),
              ],
            ),
            const SizedBox(height: 16),

            // Lista “di oggi” (per semplicità mostriamo tutti)
            ValueListenableBuilder<Box<FarmacoModel>>(
              valueListenable: box.listenable(),
              builder: (context, box, _) {
                final farmaci = box.values.toList();
                if (farmaci.isEmpty) {
                  return const Center(child: Text('Nessun farmaco presente'));
                }
                return Column(
                  children: farmaci.map((f) {
                    return FarmacoGiornoCard(
                      nome: f.nome,
                      dose: f.dose,
                      orario: f.orario,
                      statoColore: Colors.green, // qui scegli colore in base allo stato reale
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 32),

            // Sezione: Tutti i Farmaci
            const Text(
              'Tutti i Farmaci',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            ValueListenableBuilder<Box<FarmacoModel>>(
              valueListenable: box.listenable(),
              builder: (context, box, _) {
                final all = box.values.toList();
                return Column(
                  children: all.map((f) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${f.nome} ${f.dose}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DettagliFarmacoPage(farmaco: f),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5DB47F),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                            ),
                            child: const Text('Dettagli'),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 32),

            // Pulsante Aggiungi Farmaco
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AggiungiFarmacoPage()),
                  );
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Aggiungi farmaco',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5DB47F),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

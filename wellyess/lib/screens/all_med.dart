import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wellyess/models/farmaco_model.dart';
import 'package:wellyess/screens/add_new_med.dart';
import 'package:wellyess/screens/med_details.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/custom_main_button.dart';

class AllMedsPage extends StatelessWidget {
  const AllMedsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<FarmacoModel>('farmaci');

    return BaseLayout(
      currentIndex: 1,
      onBackPressed: () => Navigator.pop(context),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sezione superiore che si espande e scorre
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Tutta la Terapia',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const Divider(thickness: 1.5, height: 40),
                    const SizedBox(height: 10),
                    ValueListenableBuilder<Box<FarmacoModel>>(
                      valueListenable: box.listenable(),
                      builder: (context, box, _) {
                        final farmaciEntries = box.toMap().entries.toList();

                        if (farmaciEntries.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.0),
                              child: Text(
                                'Nessun farmaco aggiunto.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey),
                              ),
                            ),
                          );
                        }

                        farmaciEntries.sort((a, b) => a.value.nome
                            .toLowerCase()
                            .compareTo(b.value.nome.toLowerCase()));

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: farmaciEntries.length,
                          itemBuilder: (context, index) {
                            final entry = farmaciEntries[index];
                            final farmaco = entry.value;
                            final farmacoKey = entry.key;

                            return Card(
                              color: Colors.white,
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 4.0),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.medication_outlined,
                                  color: Color(0xFF5DB47F),
                                  size: 30,
                                ),
                                title: Text(
                                  farmaco.nome,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                    '${farmaco.dose} - ${farmaco.frequenza}'),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DettagliFarmacoPage(
                                        farmaco: farmaco,
                                        farmacoKey: farmacoKey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Pulsante fisso in basso
            const SizedBox(height: 20),
            CustomMainButton(
              text: '+ Aggiungi farmaco',
              color: const Color(0xFF5DB47F),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const AggiungiFarmacoPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
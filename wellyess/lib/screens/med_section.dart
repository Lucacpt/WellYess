import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wellyess/models/farmaco_model.dart';
import 'package:wellyess/screens/all_med.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/confirm_popup.dart';
import 'package:wellyess/widgets/med_legenda.dart';
import 'package:wellyess/screens/med_details.dart';
import 'package:wellyess/widgets/custom_main_button.dart';
import 'package:wellyess/widgets/med_card.dart';

class FarmaciPage extends StatefulWidget {
  const FarmaciPage({Key? key}) : super(key: key);

  @override
  State<FarmaciPage> createState() => _FarmaciPageState();
}

class _FarmaciPageState extends State<FarmaciPage> {
  final Map<dynamic, Color> _statiFarmaci = {};
  late final Box<FarmacoModel> _farmaciBox;

  @override
  void initState() {
    super.initState();
    _farmaciBox = Hive.box<FarmacoModel>('farmaci');
    for (var key in _farmaciBox.keys) {
      _statiFarmaci[key] = Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      currentIndex: 1,
      onBackPressed: () => Navigator.of(context).pop(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Text(
                        'Farmaci',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Divider(thickness: 1.5, height: 40),
                    const Text(
                      'Farmaci di Oggi',
                      style:
                          TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        LegendaPallino(text: 'Assunto', color: Colors.green),
                        LegendaPallino(text: 'In attesa', color: Colors.orange),
                        LegendaPallino(text: 'Saltato', color: Colors.red),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.blue.shade700, size: 25),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Tocca un farmaco per segnarlo come 'Assunto' o 'Saltato'.",
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ValueListenableBuilder<Box<FarmacoModel>>(
                      valueListenable: _farmaciBox.listenable(),
                      builder: (context, box, _) {
                        final farmaciKeys = box.keys.toList();

                        for (var key in farmaciKeys) {
                          _statiFarmaci.putIfAbsent(key, () => Colors.orange);
                        }

                        if (farmaciKeys.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.0),
                              child: Text('Nessun farmaco aggiunto.'),
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: farmaciKeys.length,
                          itemBuilder: (context, index) {
                            final key = farmaciKeys[index];
                            final farmaco = box.get(key);

                            if (farmaco == null) return const SizedBox.shrink();

                            final coloreStato =
                                _statiFarmaci[key] ?? Colors.orange;

                            return Column(
                              key: ValueKey(key),
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                FarmacoCard(
                                  statoColore: coloreStato,
                                  orario: farmaco.orario,
                                  nome: farmaco.nome,
                                  dose: farmaco.dose,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return ConfirmDialog(
                                          titleText:
                                              'Hai assunto ${farmaco.nome}?',
                                          cancelButtonText: 'Sì',
                                          confirmButtonText: 'No',
                                          onCancel: () {
                                            setState(() {
                                              _statiFarmaci[key] =
                                                  Colors.green;
                                            });
                                            Navigator.of(dialogContext).pop();
                                          },
                                          onConfirm: () {
                                            setState(() {
                                              _statiFarmaci[key] = Colors.red;
                                            });
                                            Navigator.of(dialogContext).pop();
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                                const SizedBox(height: 10),
                                const Divider(thickness: 1.5, height: 40),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomMainButton(
              text: 'Vedi tutti i farmaci',
              color: const Color(0xFF5DB47F),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AllMedsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
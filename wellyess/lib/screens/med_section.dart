import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart'; // <-- Aggiunto questo import
import 'package:wellyess/models/farmaco_model.dart';
import 'package:wellyess/screens/all_med.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/confirm_popup.dart';
import 'package:wellyess/widgets/med_legenda.dart';
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
      _statiFarmaci.putIfAbsent(key, () => Colors.orange);
    }
  }

  // NUOVO: Helper per interpretare qualsiasi stringa di orario
  DateTime? _parseTime(String timeString) {
    try {
      // Prova a interpretare il formato "h:mm a" (es. "8:00 PM")
      return DateFormat("h:mm a").parse(timeString);
    } catch (e) {
      try {
        // Se fallisce, prova a interpretare il formato "HH:mm" (es. "20:00")
        return DateFormat("HH:mm").parse(timeString);
      } catch (e) {
        // Se entrambi falliscono, non è un formato valido
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BaseLayout(
      currentIndex: 1,
      onBackPressed: () => Navigator.of(context).pop(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04)
                    .copyWith(bottom: screenHeight * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        'Farmaci',
                        style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Divider(
                        thickness: 1.5,
                        height: screenHeight * 0.05),
                    Text(
                      'Farmaci di Oggi',
                      style: TextStyle(
                          fontSize: screenWidth * 0.055,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        LegendaPallino(text: 'Assunto', color: Colors.green),
                        LegendaPallino(text: 'In attesa', color: Colors.orange),
                        LegendaPallino(text: 'Saltato', color: Colors.red),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.blue.shade700,
                            size: screenWidth * 0.06),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: Text(
                            "Tocca un farmaco per segnarlo come 'Assunto' o 'Saltato'.",
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    ValueListenableBuilder<Box<FarmacoModel>>(
                      valueListenable: _farmaciBox.listenable(),
                      builder: (context, box, _) {
                        final farmaciKeys = box.keys.toList();

                        for (var key in farmaciKeys) {
                          _statiFarmaci.putIfAbsent(key, () => Colors.orange);
                        }

                        // MODIFICATO: Ordinamento robusto basato sull'orario reale
                        farmaciKeys.sort((a, b) {
                          final farmacoA = box.get(a);
                          final farmacoB = box.get(b);
                          if (farmacoA == null || farmacoB == null) return 0;
                          
                          final timeA = _parseTime(farmacoA.orario);
                          final timeB = _parseTime(farmacoB.orario);

                          if (timeA == null || timeB == null) return 0;
                          return timeA.compareTo(timeB);
                        });

                        if (farmaciKeys.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.05),
                              child: Text(
                                'Nessun farmaco aggiunto.',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  color: Colors.grey.shade600,
                                ),
                              ),
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
                            
                            // MODIFICATO: Formatta sempre l'orario in 24 ore per la visualizzazione
                            final orario24h = _parseTime(farmaco.orario);
                            final orarioDaMostrare = orario24h != null
                                ? DateFormat('HH:mm').format(orario24h)
                                : farmaco.orario; // Fallback

                            return Column(
                              key: ValueKey(key),
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                FarmacoCard(
                                  statoColore: coloreStato,
                                  orario: orarioDaMostrare, // Usa l'orario formattato
                                  nome: farmaco.nome,
                                  dose: farmaco.dose,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext dialogContext) {
                                        return ConfirmDialog(
                                          titleText:
                                              'Hai assunto ${farmaco.nome}?',
                                          confirmButtonText: 'Sì',
                                          cancelButtonText: 'No',
                                          onConfirm: () {
                                            setState(() {
                                              _statiFarmaci[key] =
                                                  Colors.green;
                                            });
                                            Navigator.of(dialogContext).pop();
                                          },
                                          onCancel: () {
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
                                SizedBox(
                                    height: screenHeight *
                                        0.012),
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
            SizedBox(height: screenHeight * 0.012),
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
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/models/farmaco_model.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/screens/all_med.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/confirm_popup.dart';
import 'package:wellyess/widgets/med_legenda.dart';
import 'package:wellyess/widgets/custom_main_button.dart';
import 'package:wellyess/widgets/med_card.dart';
import 'package:wellyess/main.dart'; // Per farmacoDaMostrare
import 'package:wellyess/services/notification_service.dart'; // Per sendFarmacoNotification

class FarmaciPage extends StatefulWidget {
  const FarmaciPage({Key? key}) : super(key: key);

  @override
  State<FarmaciPage> createState() => _FarmaciPageState();
}

class _FarmaciPageState extends State<FarmaciPage> {
  final Map<dynamic, Color> _statiFarmaci = {};
  late final Box<FarmacoModel> _farmaciBox;
  UserType? _userType;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserTypeAndData();

    // Mostra il popup se la pagina viene aperta dalla notifica
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (farmacoDaMostrare != null) {
        final key = int.tryParse(farmacoDaMostrare!);
        farmacoDaMostrare = null;
        if (key != null) {
          final farmaco = Hive.box<FarmacoModel>('farmaci').get(key);
          if (farmaco != null) {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return ConfirmDialog(
                  titleText: 'Hai assunto ${farmaco.nome}?',
                  confirmButtonText: 'Sì',
                  cancelButtonText: 'No',
                  onConfirm: () {
                    setState(() {
                      _statiFarmaci[key] = Colors.green;
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
          }
        }
      }
    });
  }

  Future<void> _loadUserTypeAndData() async {
    final prefs = await SharedPreferences.getInstance();
    final userTypeString = prefs.getString('userType');

    _farmaciBox = Hive.box<FarmacoModel>('farmaci');
    for (var key in _farmaciBox.keys) {
      _statiFarmaci.putIfAbsent(key, () => Colors.orange);
    }

    if (mounted) {
      setState(() {
        if (userTypeString != null) {
          _userType =
              UserType.values.firstWhere((e) => e.toString() == userTypeString);
        }
        _isLoading = false;
      });
    }
  }

  DateTime? _parseTime(String timeString) {
    try {
      return DateFormat("h:mm a").parse(timeString);
    } catch (e) {
      try {
        return DateFormat("HH:mm").parse(timeString);
      } catch (e) {
        return null;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Stampa le chiavi dei farmaci in console per debug
    final farmaciKeys = Hive.box<FarmacoModel>('farmaci').keys.toList();
    print('Chiavi farmaci disponibili: $farmaciKeys');

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isCaregiver = _userType == UserType.caregiver;

    return BaseLayout(
      userType: _userType,
      currentIndex: 1,
      onBackPressed: () => Navigator.of(context).pop(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04)
            .copyWith(bottom: screenHeight * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Pulsante di test per inviare una notifica
            ElevatedButton(
              onPressed: () {
                if (farmaciKeys.isNotEmpty) {
                  // Prendi la prima chiave e il nome del farmaco associato
                  final testKey = farmaciKeys.first;
                  final testFarmaco = Hive.box<FarmacoModel>('farmaci').get(testKey);
                  if (testFarmaco != null) {
                    sendFarmacoNotification(testKey.toString(), testFarmaco.nome);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Notifica inviata per ${testFarmaco.nome} (key: $testKey)')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nessun farmaco disponibile per il test')),
                  );
                }
              },
              child: const Text('Test Notifica Farmaco'),
            ),
            SizedBox(height: screenHeight * 0.012),
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
                    Divider(thickness: 1.5, height: screenHeight * 0.05),
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
                    if (!isCaregiver)
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

                            final orario24h = _parseTime(farmaco.orario);
                            final orarioDaMostrare = orario24h != null
                                ? DateFormat('HH:mm').format(orario24h)
                                : farmaco.orario;

                            return Column(
                              key: ValueKey(key),
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                FarmacoCard(
                                  statoColore: coloreStato,
                                  orario: orarioDaMostrare,
                                  nome: farmaco.nome,
                                  dose: farmaco.dose,
                                  onTap: isCaregiver
                                      ? null
                                      : () {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (BuildContext dialogContext) {
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
                                                  Navigator.of(dialogContext)
                                                      .pop();
                                                },
                                                onCancel: () {
                                                  setState(() {
                                                    _statiFarmaci[key] =
                                                        Colors.red;
                                                  });
                                                  Navigator.of(dialogContext)
                                                      .pop();
                                                },
                                              );
                                            },
                                          );
                                        },
                                ),
                                SizedBox(height: screenHeight * 0.012),
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
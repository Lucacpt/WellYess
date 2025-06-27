import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/models/parameter_model.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/custom_main_button.dart';
import 'package:wellyess/widgets/med_card.dart';
import 'add_new_parameters.dart';
import 'monitoring_history_page.dart';

class MonitoraggioParametriPage extends StatefulWidget {
  const MonitoraggioParametriPage({super.key});

  @override
  State<MonitoraggioParametriPage> createState() =>
      _MonitoraggioParametriPageState();
}

class _MonitoraggioParametriPageState extends State<MonitoraggioParametriPage> {
  UserType? _userType;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    final prefs = await SharedPreferences.getInstance();
    final userTypeString = prefs.getString('userType');
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isCaregiver = _userType == UserType.caregiver;
    final box = Hive.box<ParameterEntry>('parameters');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BaseLayout(
      userType: _userType,
      currentIndex: 3,
      onBackPressed: () => Navigator.pop(context),
      child: ValueListenableBuilder<Box<ParameterEntry>>(
        valueListenable: box.listenable(),
        builder: (context, box, _) {
          final entries = box.values.toList()
            ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
          final last = entries.isNotEmpty ? entries.first : null;

          final Color generalStatusColor =
              last != null ? _getGeneralStatusColor(last) : Colors.green.shade400;
          final IconData generalStatusIcon =
              generalStatusColor == Colors.green.shade400
                  ? Icons.check_circle
                  : generalStatusColor == Colors.orange.shade700
                      ? Icons.error_outline
                      : Icons.cancel;
          final String generalStatusText =
              generalStatusColor == Colors.green.shade400
                  ? 'Buona Salute Oggi'
                  : generalStatusColor == Colors.orange.shade700
                      ? 'Valori da controllare'
                      : 'Valori fuori norma';

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Titolo
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Monitoraggio Parametri',
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                const Divider(),
                SizedBox(height: screenHeight * 0.02),

                // Card stato generale
                if (last != null)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Barra colorata con icona e testo
                        Container(
                          decoration: BoxDecoration(
                            color: generalStatusColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.045,
                            vertical: screenHeight * 0.018,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                generalStatusIcon,
                                color: Colors.white,
                                size: screenWidth * 0.07,
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    generalStatusText,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.048,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Ultima Misurazione: ${TimeOfDay.fromDateTime(last.timestamp).format(context)}',
                                    style: TextStyle(
                                      color: Colors.green.shade100,
                                      fontSize: screenWidth * 0.035,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Messaggio sotto la barra colorata
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.045,
                            vertical: screenHeight * 0.018,
                          ),
                          child: Text(
                            _getStatusMessage(last),
                            style: TextStyle(
                              fontSize: screenWidth * 0.042,
                              color: Colors.grey.shade800,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    elevation: 6,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.025,
                      ),
                      child: Center(
                        child: Text(
                          "Nessun dato disponibile",
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: screenHeight * 0.025),

                // Card parametri
                if (last != null) ...[
                  FarmacoCard(
                    statoColore: _getColor(last.sys, 90, 140),
                    orario: "Pressione",
                    nome: "${last.sys} / ${last.dia}",
                    dose: "mmHg",
                    isHighlighted: false,
                  ),
                  FarmacoCard(
                    statoColore: _getColor(last.bpm, 60, 100),
                    orario: "Battito",
                    nome: "${last.bpm}",
                    dose: "MBP",
                    isHighlighted: false,
                  ),
                  FarmacoCard(
                    statoColore: _getColor(last.hgt, 70, 110),
                    orario: "Glicemia",
                    nome: "${last.hgt}",
                    dose: "MG/DL",
                    isHighlighted: false,
                  ),
                  FarmacoCard(
                    statoColore: _getColor(last.spo2, 95, 100),
                    orario: "Saturazione",
                    nome: "${last.spo2}",
                    dose: "%",
                    isHighlighted: false,
                  ),
                ],
                SizedBox(height: screenHeight * 0.01),

                // Vedi storico
                if (last != null)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MonitoringHistoryPage()),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.012),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Vedi Storico",
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.015),
                          Icon(Icons.bar_chart,
                              color: Colors.black,
                              size: screenWidth * 0.06),
                        ],
                      ),
                    ),
                  ),

                SizedBox(height: screenHeight * 0.02),

                // Pulsante aggiungi parametri
                if (!isCaregiver)
                  CustomMainButton(
                    text: '+ Aggiungi parametri',
                    color: const Color(0xFF5DB47F),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AggiungiMonitoraggioPage()),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Funzione per messaggio stato generale
  String _getStatusMessage(ParameterEntry entry) {
    if (entry.sys >= 90 &&
        entry.sys <= 140 &&
        entry.dia >= 60 &&
        entry.dia <= 90 &&
        entry.bpm >= 60 &&
        entry.bpm <= 100 &&
        entry.hgt >= 70 &&
        entry.hgt <= 110 &&
        entry.spo2 >= 95) {
      return "Tutti i valori sono nella norma!";
    } else {
      return "Alcuni valori sono fuori norma. Consulta il tuo medico.";
    }
  }

  // Funzione per colore stato generale
  Color _getGeneralStatusColor(ParameterEntry entry) {
    int outOfRange = 0;
    if (entry.sys < 90 || entry.sys > 140) outOfRange++;
    if (entry.dia < 60 || entry.dia > 90) outOfRange++;
    if (entry.bpm < 60 || entry.bpm > 100) outOfRange++;
    if (entry.hgt < 70 || entry.hgt > 110) outOfRange++;
    if (entry.spo2 < 95) outOfRange++;

    if (outOfRange == 0) return Colors.green.shade400;
    if (outOfRange == 1) return Colors.orange.shade700;
    return Colors.red.shade400;
  }

  // Funzione per colore stato parametro
  Color _getColor(num value, num min, num max) {
    if (value < min || value > max) {
      // Se molto fuori range, rosso
      if (value < min * 0.9 || value > max * 1.1) {
        return Colors.red.shade400;
      }
      // Se poco fuori range, arancione
      return Colors.orange.shade700;
    }
    return Colors.green;
  }
}
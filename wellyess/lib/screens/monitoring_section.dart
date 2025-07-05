import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/parameter_model.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/custom_main_button.dart';
import 'package:wellyess/widgets/med_card.dart';
import 'package:wellyess/widgets/tappable_reader.dart';
import 'package:wellyess/services/flutter_tts.dart';
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

    // Accessibilità
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    return BaseLayout(
      pageTitle: 'Monitoraggio Parametri',  // ← titolo da annunciare
      userType: _userType,
      currentIndex: 3,
      onBackPressed: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // HEADER FISSO
          TappableReader(
            label: 'Titolo pagina Monitoraggio Parametri',
            child: Center(
              child: Text(
                'Monitoraggio Parametri',
                style: TextStyle(
                  fontSize: (screenWidth * 0.07 * fontSizeFactor).clamp(22.0, 40.0),
                  fontWeight: FontWeight.bold,
                  color: highContrast ? Colors.black : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Divider(
            color:Colors.grey,
            thickness: 1,
          ),

          // CONTENUTO SCORRIBILE
          Expanded(
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
                    vertical: screenHeight * 0.01,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Card stato generale
                      if (last != null)
                        Semantics(
                          label:
                              'Stato generale: $generalStatusText. Ultima misurazione alle ${TimeOfDay.fromDateTime(last.timestamp).format(context)}. ${_getStatusMessage(last)}',
                          child: Container(
                            decoration: BoxDecoration(
                              color: highContrast ? Colors.yellow.shade700 : Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: highContrast
                                  ? Border.all(color: Colors.black, width: 2)
                                  : null,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Barra colorata con icona e testo
                                Container(
                                  decoration: BoxDecoration(
                                    color: highContrast ? Colors.black : generalStatusColor,
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        generalStatusIcon,
                                        color: highContrast ? Colors.yellow.shade700 : Colors.white,
                                        size: (screenWidth * 0.09 * fontSizeFactor).clamp(28.0, 44.0),
                                      ),
                                      SizedBox(width: screenWidth * 0.03),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              generalStatusText,
                                              style: TextStyle(
                                                color: highContrast ? Colors.yellow.shade700 : Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: (screenWidth * 0.06 * fontSizeFactor).clamp(20.0, 32.0),
                                              ),
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              'Ultima Misurazione: ${TimeOfDay.fromDateTime(last.timestamp).format(context)}',
                                              style: TextStyle(
                                                color: highContrast ? Colors.yellow.shade700 : Colors.green.shade100,
                                                fontSize: (screenWidth * 0.045 * fontSizeFactor).clamp(16.0, 24.0),
                                                fontWeight: FontWeight.w600,
                                              ),
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            ),
                                          ],
                                        ),
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
                                      fontSize: (screenWidth * 0.05 * fontSizeFactor).clamp(16.0, 26.0),
                                      color: highContrast ? Colors.black : Colors.grey.shade800,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Semantics(
                          label: 'Nessun dato disponibile',
                          child: Card(
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
                                    fontSize: (screenWidth * 0.045 * fontSizeFactor).clamp(12.0, 18.0),
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: screenHeight * 0.025),

                      // Card parametri
                      if (last != null) ...[
                        TappableReader(
                          label: 'Pressione ${last.sys}/${last.dia} millimetri di mercurio',
                          child: FarmacoCard(
                            statoColore: _getColor(last.sys, 90, 140),
                            orario: "Pressione",
                            nome: "${last.sys} / ${last.dia}",
                            dose: "mmHg",
                            isHighlighted: false,
                          ),
                        ),
                        TappableReader(
                          label: 'Battito cardiaco ${last.bpm} battiti per minuto',
                          child: FarmacoCard(
                            statoColore: _getColor(last.bpm, 60, 100),
                            orario: "Battito",
                            nome: "${last.bpm}",
                            dose: "MBP",
                            isHighlighted: false,
                          ),
                        ),
                        TappableReader(
                          label: 'Glicemia ${last.hgt} milligrammi per decilitro',
                          child: FarmacoCard(
                            statoColore: _getColor(last.hgt, 70, 110),
                            orario: "Glicemia",
                            nome: "${last.hgt}",
                            dose: "MG/DL",
                            isHighlighted: false,
                          ),
                        ),
                        TappableReader(
                          label: 'Saturazione ossigeno ${last.spo2} percento',
                          child: FarmacoCard(
                            statoColore: _getColor(last.spo2, 95, 100),
                            orario: "Saturazione",
                            nome: "${last.spo2}",
                            dose: "%",
                            isHighlighted: false,
                          ),
                        ),
                      ],
                      SizedBox(height: screenHeight * 0.01),

                      // Vedi storico
                      if (last != null)
                        // Ripristino link a Storico monitoraggi e reso leggibile
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.012),
                          child: TappableReader(
                            label: 'Vedi storico monitoraggi',
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MonitoringHistoryPage(),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Vedi Storico",
                                    style: TextStyle(
                                      fontSize: (screenWidth * 0.045 * fontSizeFactor).clamp(13.0, 20.0),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      color: highContrast ? Colors.black : Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: screenWidth * 0.015),
                                  Icon(
                                    Icons.bar_chart,
                                    color: highContrast ? Colors.black : Colors.black,
                                    size: (screenWidth * 0.06 * fontSizeFactor).clamp(18.0, 28.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  )
                );
              },
            ),
          ),

          // FOOTER FISSO: Pulsante aggiungi parametri
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04)
                .copyWith(bottom: screenHeight * 0.01, top: screenHeight * 0.01),
            child: TappableReader(
              label: 'Bottone Aggiungi parametri',
              child: CustomMainButton(
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
            ),
          ),
        ],
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
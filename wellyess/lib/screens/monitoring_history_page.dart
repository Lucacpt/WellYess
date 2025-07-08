import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wellyess/models/parameter_model.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/med_card.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import 'package:wellyess/widgets/tappable_reader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/models/user_model.dart';

// Pagina che mostra lo storico dei monitoraggi dei parametri vitali
class MonitoringHistoryPage extends StatefulWidget {
  const MonitoringHistoryPage({super.key});

  @override
  State<MonitoringHistoryPage> createState() => _MonitoringHistoryPageState();
}

class _MonitoringHistoryPageState extends State<MonitoringHistoryPage> {
  UserType? _userType; // Tipo utente (caregiver, anziano, ecc.)
  bool _isLoading = true; // Stato di caricamento

  @override
  void initState() {
    super.initState();
    _loadUserType(); // Carica il tipo di utente dalle preferenze
  }

  // Carica il tipo di utente dalle SharedPreferences
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

  // Restituisce un colore in base al valore del parametro rispetto ai limiti
  Color _getColor(num value, num min, num max) {
    if (value < min || value > max) {
      if (value < min * 0.9 || value > max * 1.1) {
        return Colors.red.shade400; // Fuori range critico
      }
      return Colors.orange.shade700; // Fuori range ma non critico
    }
    return Colors.green; // Valore nella norma
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<ParameterEntry>('parameters'); // Box Hive dei parametri
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Accessibilità: recupera i valori dal provider
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    // Mostra loader se i dati sono in caricamento
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BaseLayout(
      pageTitle: 'Storico Monitoraggi', // Titolo della pagina nella barra superiore
      userType: _userType,
      onBackPressed: () => Navigator.pop(context),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Titolo pagina
            TappableReader(
              label: 'Titolo pagina Storico Monitoraggi',
              child: Text(
                'Storico Monitoraggi',
                style: TextStyle(
                  fontSize: (screenWidth * 0.07 * fontSizeFactor).clamp(22.0, 32.0),
                  fontWeight: FontWeight.bold,
                  color: highContrast ? Colors.black : Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Divider(
              color: highContrast ? Colors.black : Colors.grey,
              thickness: 1.2,
            ),
            // Lista degli storici dei parametri
            Expanded(
              child: ValueListenableBuilder<Box<ParameterEntry>>(
                valueListenable: box.listenable(),
                builder: (context, box, _) {
                  // Ordina le entry dal più recente al meno recente
                  final entries = box.values.toList()
                    ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
                  if (entries.isEmpty) {
                    // Messaggio se non ci sono dati salvati
                    return Center(
                      child: TappableReader(
                        label: 'Nessun dato salvato',
                        child: Text(
                          'Nessun dato salvato',
                          style: TextStyle(
                            fontSize: (screenWidth * 0.045 * fontSizeFactor).clamp(14.0, 20.0),
                            color: highContrast ? Colors.black : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    );
                  }
                  // Lista dei monitoraggi
                  return ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => Column(
                      children: [
                        SizedBox(height: screenHeight * 0.01),
                        Divider(
                          thickness: 1.2,
                          color: highContrast ? Colors.black : Colors.grey,
                        ),
                        SizedBox(height: screenHeight * 0.01),
                      ],
                    ),
                    itemBuilder: (context, index) {
                      final e = entries[index];
                      final time = TimeOfDay.fromDateTime(e.timestamp);
                      final dateStr = "${e.timestamp.day}/${e.timestamp.month}/${e.timestamp.year} - ${time.format(context)}";
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Data e ora del monitoraggio
                          TappableReader(
                            label: 'Data monitoraggio $dateStr',
                            child: Text(
                              dateStr,
                              style: TextStyle(
                                fontSize: (screenWidth * 0.04 * fontSizeFactor).clamp(13.0, 18.0),
                                color: highContrast ? Colors.black : Colors.grey.shade600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Card Pressione arteriosa
                          TappableReader(
                            label: 'Pressione ${e.sys}/${e.dia} mmHg',
                            child: FarmacoCard(
                              statoColore: _getColor(e.sys, 90, 140),
                              orario: "Pressione",
                              nome: "${e.sys} / ${e.dia}",
                              dose: "mmHg",
                            ),
                          ),
                          // Card Battito cardiaco
                          TappableReader(
                            label: 'Battito ${e.bpm} BPM',
                            child: FarmacoCard(
                              statoColore: _getColor(e.bpm, 60, 100),
                              orario: "Battito",
                              nome: "${e.bpm}",
                              dose: "MBP",
                            ),
                          ),
                          // Card Glicemia
                          TappableReader(
                            label: 'Glicemia ${e.hgt} MG/DL',
                            child: FarmacoCard(
                              statoColore: _getColor(e.hgt, 70, 110),
                              orario: "Glicemia",
                              nome: "${e.hgt}",
                              dose: "MG/DL",
                            ),
                          ),
                          // Card Saturazione
                          TappableReader(
                            label: 'Saturazione ${e.spo2} percento',
                            child: FarmacoCard(
                              statoColore: _getColor(e.spo2, 95, 100),
                              orario: "Saturazione",
                              nome: "${e.spo2}",
                              dose: "%",
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
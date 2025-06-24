import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/models/parameter_model.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/custom_main_button.dart';
import 'package:wellyess/widgets/parameters_card.dart';
import 'package:wellyess/widgets/pressure_chart.dart';
import 'package:wellyess/widgets/glucose_chart.dart';
import 'package:wellyess/widgets/oxygen_chart.dart';
import 'add_new_parameters.dart';

// MODIFICA: Convertito in StatefulWidget
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
    // MODIFICA: Mostra una schermata di caricamento per evitare lo sfarfallio
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isCaregiver = _userType == UserType.caregiver;

    // dati fittizi di esempio per i grafici
    final diaData = [
      const FlSpot(0, 80),
      const FlSpot(1, 82),
      const FlSpot(2, 78),
      const FlSpot(3, 85),
      const FlSpot(4, 84)
    ];
    final sysData = [
      const FlSpot(0, 130),
      const FlSpot(1, 132),
      const FlSpot(2, 128),
      const FlSpot(3, 135),
      const FlSpot(4, 134)
    ];
    final bpmData = [
      const FlSpot(0, 70),
      const FlSpot(1, 72),
      const FlSpot(2, 68),
      const FlSpot(3, 75),
      const FlSpot(4, 74)
    ];
    final hgtData = [
      const FlSpot(0, 5.5),
      const FlSpot(1, 5.8),
      const FlSpot(2, 6.0),
      const FlSpot(3, 5.7),
      const FlSpot(4, 5.9)
    ];
    final spo2Data = [
      const FlSpot(0, 97),
      const FlSpot(1, 96),
      const FlSpot(2, 98),
      const FlSpot(3, 95),
      const FlSpot(4, 97)
    ];

    final box = Hive.box<ParameterEntry>('parameters');

    return BaseLayout(
      // MODIFICA: Passa il tipo di utente corretto
      userType: _userType,
      currentIndex: 3,
      onBackPressed: () => Navigator.pop(context),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Monitoraggio Parametri',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(),
            const SizedBox(height: 24),
            PressureChart(diaData: diaData, sysData: sysData, bpmData: bpmData),
            const SizedBox(height: 20),
            GlucoseChart(hgtData: hgtData),
            const SizedBox(height: 20),
            OxygenChart(spo2Data: spo2Data),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            const Text(
              'Storico Registrazioni',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16),
            ValueListenableBuilder<Box<ParameterEntry>>(
              valueListenable: box.listenable(),
              builder: (context, box, _) {
                final entries = box.values.toList()
                  ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
                if (entries.isEmpty) {
                  return const Center(child: Text('Nessun dato salvato'));
                }
                return Column(
                  children: entries.map((e) {
                    final time = TimeOfDay.fromDateTime(e.timestamp);
                    return TodayParametersCard(
                      time: time,
                      sys: e.sys,
                      dia: e.dia,
                      bpm: e.bpm,
                      hgt: e.hgt,
                      spo2: e.spo2,
                    );
                  }).toList(),
                );
              },
            ),
            // MODIFICA: Il pulsante viene mostrato solo se non è un caregiver
            
              const SizedBox(height: 24),
              CustomMainButton(
                text: '+ Aggiungi Parametri',
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
      ),
    );
  }
}
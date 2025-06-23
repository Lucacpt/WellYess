import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wellyess/models/parameter_model.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/custom_main_button.dart';
import 'package:wellyess/widgets/parameters_card.dart';
import 'package:wellyess/widgets/pressure_chart.dart';
import 'package:wellyess/widgets/glucose_chart.dart';
import 'package:wellyess/widgets/oxygen_chart.dart';
import 'add_new_parameters.dart';

class MonitoraggioParametriPage extends StatelessWidget {
  const MonitoraggioParametriPage({super.key});

  @override
  Widget build(BuildContext context) {
    // dati fittizi di esempio per i grafici
    final diaData = [FlSpot(0, 80), FlSpot(1, 82), FlSpot(2, 78), FlSpot(3, 85), FlSpot(4, 84)];
    final sysData = [FlSpot(0, 130), FlSpot(1, 132), FlSpot(2, 128), FlSpot(3, 135), FlSpot(4, 134)];
    final bpmData = [FlSpot(0, 70), FlSpot(1, 72), FlSpot(2, 68), FlSpot(3, 75), FlSpot(4, 74)];
    final hgtData = [FlSpot(0, 5.5), FlSpot(1, 5.8), FlSpot(2, 6.0), FlSpot(3, 5.7), FlSpot(4, 5.9)];
    final spo2Data = [FlSpot(0, 97), FlSpot(1, 96), FlSpot(2, 98), FlSpot(3, 95), FlSpot(4, 97)];

    final box = Hive.box<ParameterEntry>('parameters');

    return BaseLayout(
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

            // Chart fittizio
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

            // sezione dinamica dai dati in Hive
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

            const SizedBox(height: 24),
            CustomMainButton(
              text: '+ Aggiungi Parametri',
              color: const Color(0xFF5DB47F),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AggiungiMonitoraggioPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Per FlSpot
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
    // Dati fittizi di esempio per grafici (FlSpot(x, y))
    final List<FlSpot> diaData = [
      FlSpot(0, 80),
      FlSpot(1, 82),
      FlSpot(2, 78),
      FlSpot(3, 85),
      FlSpot(4, 84),
    ];
    final List<FlSpot> sysData = [
      FlSpot(0, 130),
      FlSpot(1, 135),
      FlSpot(2, 138),
      FlSpot(3, 140),
      FlSpot(4, 142),
    ];
    final List<FlSpot> bpmData = [
      FlSpot(0, 75),
      FlSpot(1, 78),
      FlSpot(2, 80),
      FlSpot(3, 85),
      FlSpot(4, 90),
    ];

    final List<FlSpot> hgtData = [
      FlSpot(0, 70),
      FlSpot(1, 72),
      FlSpot(2, 75),
      FlSpot(3, 78),
      FlSpot(4, 78),
    ];

    final List<FlSpot> spo2Data = [
      FlSpot(0, 95),
      FlSpot(1, 96),
      FlSpot(2, 97),
      FlSpot(3, 98),
      FlSpot(4, 97),
    ];

    return BaseLayout(
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
                textAlign: TextAlign.center
              ),
            ),

            const Divider(),
            const SizedBox(height: 24),

            TodayParametersCard(
              time: const TimeOfDay(hour: 10, minute: 30),
              sys: 140,
              dia: 84,
              bpm: 90,
              hgt: 78,
              spo2: 97,
            ),

            const SizedBox(height: 24),

            CustomMainButton(
              text: '+ Aggiungi Parametri',
              color: const Color(0xFF5DB47F),
              onTap: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AggiungiMonitoraggioPage(),
                        ),
                      );
              },
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: const Icon(Icons.keyboard_arrow_down, size: 28, color: Colors.black87),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Scorri per vedere lo storico',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            const Text(
              'Storico',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),

            const SizedBox(height: 16),

    

            PressureChart(
              diaData: diaData,
              sysData: sysData,
              bpmData: bpmData,
            ),

            const SizedBox(height: 20),

            GlucoseChart(hgtData: hgtData),

            const SizedBox(height: 20),

            OxygenChart(spo2Data: spo2Data),
          ],
        ),
      ),
    );
  }
}

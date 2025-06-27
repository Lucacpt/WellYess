import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wellyess/models/parameter_model.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/med_card.dart';

class MonitoringHistoryPage extends StatelessWidget {
  const MonitoringHistoryPage({super.key});

  Color _getColor(num value, num min, num max) {
    if (value < min || value > max) {
      if (value < min * 0.9 || value > max * 1.1) {
        return Colors.red.shade400;
      }
      return Colors.orange.shade700;
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<ParameterEntry>('parameters');
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BaseLayout(
      onBackPressed: () => Navigator.pop(context),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.04,
          vertical: screenHeight * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Storico Monitoraggi',
              style: TextStyle(
                fontSize: screenWidth * 0.07,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Divider(),
            Expanded(
              child: ValueListenableBuilder<Box<ParameterEntry>>(
                valueListenable: box.listenable(),
                builder: (context, box, _) {
                  final entries = box.values.toList()
                    ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
                  if (entries.isEmpty) {
                    return const Center(child: Text('Nessun dato salvato'));
                  }
                  return ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => Column(
                      children: [
                        SizedBox(height: screenHeight * 0.01),
                        const Divider(thickness: 1.2),
                        SizedBox(height: screenHeight * 0.01),
                      ],
                    ),
                    itemBuilder: (context, index) {
                      final e = entries[index];
                      final time = TimeOfDay.fromDateTime(e.timestamp);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${e.timestamp.day}/${e.timestamp.month}/${e.timestamp.year} - ${time.format(context)}",
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          FarmacoCard(
                            statoColore: _getColor(e.sys, 90, 140),
                            orario: "Pressione",
                            nome: "${e.sys} / ${e.dia}",
                            dose: "mmHg",
                          ),
                          FarmacoCard(
                            statoColore: _getColor(e.bpm, 60, 100),
                            orario: "Battito",
                            nome: "${e.bpm}",
                            dose: "MBP",
                          ),
                          FarmacoCard(
                            statoColore: _getColor(e.hgt, 70, 110),
                            orario: "Glicemia",
                            nome: "${e.hgt}",
                            dose: "MG/DL",
                          ),
                          FarmacoCard(
                            statoColore: _getColor(e.spo2, 95, 100),
                            orario: "Saturazione",
                            nome: "${e.spo2}",
                            dose: "%",
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
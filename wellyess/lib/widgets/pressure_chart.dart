import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wellyess/screens/detailed_parameters_chart.dart'; // importa la nuova schermata

class PressureChart extends StatelessWidget {
  final List<FlSpot> diaData;
  final List<FlSpot> sysData;
  final List<FlSpot> bpmData;

  const PressureChart({
    super.key,
    required this.diaData,
    required this.sysData,
    required this.bpmData,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      context: context,
      title: 'Pressione',
      iconPath: 'assets/images/pression.png',
      lines: [
        _buildLine(diaData, Colors.green, 'DIA'),
        _buildLine(sysData, Colors.cyan, 'SYS'),
        _buildLine(bpmData, Colors.red, 'BPM'),
      ],
    );
  }

  LineChartBarData _buildLine(List<FlSpot> data, Color color, String label) {
    return LineChartBarData(
      spots: data,
      isCurved: true,
      barWidth: 2,
      color: color,
      dotData: FlDotData(show: false),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String title,
    required String iconPath,
    required List<LineChartBarData> lines,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  iconPath,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailedChartScreen(
                          title: 'Pressione',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0F7FA), // cerchietto azzurrino
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_forward, size: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: lines,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

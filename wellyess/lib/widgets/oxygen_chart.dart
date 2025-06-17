import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OxygenChart extends StatelessWidget {
  final List<FlSpot> spo2Data;

  const OxygenChart({super.key, required this.spo2Data});

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: 'Saturazione',
      iconPath: 'assets/images/saturation.png',
      line: LineChartBarData(
        spots: spo2Data,
        isCurved: true,
        barWidth: 2,
        color: Colors.blue.shade800, // blu reale
        dotData: FlDotData(show: false),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String iconPath,
    required LineChartBarData line,
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
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [line],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

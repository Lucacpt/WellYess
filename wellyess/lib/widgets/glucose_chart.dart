import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GlucoseChart extends StatelessWidget {
  final List<FlSpot> hgtData;

  const GlucoseChart({super.key, required this.hgtData});

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      title: 'Glicemia',
      iconPath: 'assets/images/glycemia.png',
      line: LineChartBarData(
        spots: hgtData,
        isCurved: true,
        barWidth: 2,
        color: const Color(0xFFCC9900), // ocra
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

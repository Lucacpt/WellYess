import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wellyess/screens/detailed_parameters_chart.dart'; // importa la schermata estesa

class GlucoseChart extends StatelessWidget {
  final List<FlSpot> hgtData;

  const GlucoseChart({super.key, required this.hgtData});

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      context: context,
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
    required BuildContext context,
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
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailedChartScreen(
                          title: 'Glicemia',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF3E0), // cerchietto ocra chiaro
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

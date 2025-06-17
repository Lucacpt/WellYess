import 'package:flutter/material.dart';
import 'parameter_value_box.dart';

class TodayParametersCard extends StatelessWidget {
  final TimeOfDay time;
  final int sys, dia, bpm, hgt, spo2;

  const TodayParametersCard({
    super.key,
    required this.time,
    required this.sys,
    required this.dia,
    required this.bpm,
    required this.hgt,
    required this.spo2,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 8,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Text('Oggi alle $formattedTime',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ParameterValueBox(label: 'SYS', value: sys.toString()),
              ParameterValueBox(label: 'DIA', value: dia.toString()),
              ParameterValueBox(label: 'BPM', value: bpm.toString()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ParameterValueBox(label: 'HGT', value: hgt.toString()),
              ParameterValueBox(label: '%SpO2', value: spo2.toString()),
            ],
          ),
        ],
      ),
    );
  }
}

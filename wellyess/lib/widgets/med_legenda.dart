import 'package:flutter/material.dart';

class LegendaPallino extends StatelessWidget {
  final String text;
  final Color color;

  const LegendaPallino({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 10, backgroundColor: color),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 15)),
      ],
    );
  }
}

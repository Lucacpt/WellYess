import 'package:flutter/material.dart';

class LegendaPallino extends StatelessWidget {
  final String text;
  final Color color;

  const LegendaPallino({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        CircleAvatar(
            radius: screenWidth * 0.02, // Reso responsivo (era 10)
            backgroundColor: color),
        SizedBox(width: screenWidth * 0.015), // Reso responsivo (era 6)
        Text(text,
            style: TextStyle(
                fontSize: screenWidth * 0.038)), // Reso responsivo (era 15)
      ],
    );
  }
}
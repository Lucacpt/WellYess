import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.06 * fontSizeFactor,
            color: highContrast ? Colors.black : Colors.black,
          ),
          textAlign: TextAlign.left,
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth * 0.06 * fontSizeFactor,
            color: highContrast ? Colors.black : Colors.black,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}
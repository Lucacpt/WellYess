import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/screens/sos_details_screen.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class SosRequestCard extends StatelessWidget {
  final String personName;
  final String timestamp;
  final bool isNew;

  const SosRequestCard({
    super.key,
    required this.personName,
    required this.timestamp,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    final Color cardColor = Colors.white;
    final Color borderColor = highContrast
        ? Colors.black
        : (isNew ? Colors.red.shade300 : Colors.transparent);
    final double borderWidth = highContrast ? 2.0 : (isNew ? 2.0 : 0.0);

    final Color iconColor = isNew
        ? (highContrast ? Colors.red.shade800 : Colors.red.shade700)
        : (highContrast ? Colors.green.shade800 : Colors.green);
    final Color personTextColor = highContrast ? Colors.black : Colors.black87;
    final Color timestampColor = highContrast ? Colors.black : Colors.grey.shade600;
    final Color arrowColor = highContrast ? Colors.black : Colors.grey.shade600;
    final Color gestitaColor = highContrast ? Colors.green.shade800 : Colors.green;

    return Card(
      color: cardColor,
      elevation: 5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: InkWell(
        onTap: isNew
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SosDetailsScreen(),
                  ),
                );
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                isNew ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                color: iconColor,
                size: (screenWidth * 0.1).clamp(28.0, 44.0),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      personName,
                      style: TextStyle(
                        fontSize: (screenWidth * 0.045 * fontSizeFactor).clamp(14.0, 25.0),
                        fontWeight: FontWeight.bold,
                        color: personTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timestamp,
                      style: TextStyle(
                        fontSize: (screenWidth * 0.038 * fontSizeFactor).clamp(12.0, 20.0),
                        color: timestampColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (isNew)
                Icon(
                  Icons.arrow_forward_ios,
                  color: arrowColor,
                  size: (screenWidth * 0.05).clamp(14.0, 22.0),
                )
              else
                Text(
                  'Gestita',
                  style: TextStyle(
                    color: gestitaColor,
                    fontWeight: FontWeight.bold,
                    fontSize: (screenWidth * 0.038 * fontSizeFactor).clamp(12.0, 20.0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
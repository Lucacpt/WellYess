import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class FeatureCard extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    return Card(
      color: highContrast ? Colors.yellow.shade700 : Colors.white,
      elevation: 5,
      shadowColor: Colors.grey.shade500,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: highContrast ? const BorderSide(color: Colors.black, width: 2) : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                icon,
                SizedBox(height: screenWidth * 0.02),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.055 * fontSizeFactor,
                        fontWeight: FontWeight.bold,
                        color: highContrast ? Colors.black : Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
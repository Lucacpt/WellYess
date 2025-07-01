import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class ConfirmDialog extends StatelessWidget {
  final String titleText;
  final String cancelButtonText;
  final String confirmButtonText;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const ConfirmDialog({
    Key? key,
    required this.titleText,
    required this.cancelButtonText,
    required this.confirmButtonText,
    required this.onCancel,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    // Accessibilità
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    final Color bgColor = highContrast ? Colors.yellow.shade700 : Colors.white;
    final Color borderColor = highContrast ? Colors.black : Colors.transparent;
    final Color titleColor = highContrast ? Colors.black : Colors.black87;
    final Color cancelBg = highContrast ? Colors.black : Colors.red;
    final Color confirmBg = highContrast ? Colors.black : Colors.green;
    final Color buttonTextColor = highContrast ? Colors.yellow.shade700 : Colors.white;

    return AlertDialog(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(w * 0.05),
        side: BorderSide(color: borderColor, width: highContrast ? 2 : 0),
      ),
      title: Text(
        titleText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: (w * 0.05 * fontSizeFactor).clamp(16.0, 28.0),
          color: titleColor,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: onCancel,
          style: ElevatedButton.styleFrom(
            backgroundColor: cancelBg,
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.07,
              vertical: h * 0.015,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(w * 0.08),
            ),
            foregroundColor: buttonTextColor,
            elevation: 2,
          ),
          child: Text(
            cancelButtonText,
            style: TextStyle(
              fontSize: (w * 0.045 * fontSizeFactor).clamp(14.0, 22.0),
              color: buttonTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmBg,
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.07,
              vertical: h * 0.015,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(w * 0.08),
            ),
            foregroundColor: buttonTextColor,
            elevation: 2,
          ),
          child: Text(
            confirmButtonText,
            style: TextStyle(
              fontSize: (w * 0.045 * fontSizeFactor).clamp(14.0, 22.0),
              color: buttonTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
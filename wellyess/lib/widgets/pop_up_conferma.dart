import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class PopUpConferma extends StatelessWidget {
  final String message;
  final VoidCallback? onConfirm;

  const PopUpConferma({
    Key? key,
    required this.message,
    this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    final Color bgColor = highContrast ? Colors.yellow.shade700 : Colors.white;
    final Color borderColor = highContrast ? Colors.black : Colors.transparent;
    final Color textColor = highContrast ? Colors.black : Colors.black87;
    final Color buttonBg = highContrast ? Colors.black : Colors.redAccent;
    final Color iconColor = highContrast ? Colors.yellow.shade700 : Colors.white;

    return AlertDialog(
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: borderColor, width: highContrast ? 2 : 0),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: (18 * fontSizeFactor).clamp(15.0, 24.0),
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onConfirm != null) onConfirm!();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonBg,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
            elevation: 6,
          ),
          child: Icon(Icons.close, color: iconColor, size: 28),
        ),
      ],
    );
  }
}
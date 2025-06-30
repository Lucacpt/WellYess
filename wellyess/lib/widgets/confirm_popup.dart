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
    super.key,
    required this.titleText,
    required this.cancelButtonText,
    required this.confirmButtonText,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final access = context.watch<AccessibilitaModel>();
    final fontSize = access.fontSizeFactor;
    final highContrast = access.highContrast;

    return AlertDialog(
      backgroundColor: highContrast ? Colors.white : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
        side: highContrast ? const BorderSide(color: Colors.black, width: 2) : BorderSide.none,
      ),
      title: Text(
        titleText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: screenWidth * 0.05 * fontSize,
          color: highContrast ? Colors.black : Colors.black,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: ElevatedButton(
                onPressed: onCancel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: highContrast ? Colors.black : Colors.red,
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02, vertical: screenHeight * 0.015),
                  minimumSize: Size(0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(screenWidth * 0.08)),
                    side: highContrast ? const BorderSide(color: Colors.black, width: 2) : BorderSide.none,
                  ),
                  foregroundColor: highContrast ? Colors.yellow.shade700 : Colors.white,
                  textStyle: TextStyle(fontSize: 16 * fontSize),
                ),
                child: Text(
                  cancelButtonText,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Flexible(
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: highContrast ? Colors.yellow.shade700 : Colors.green,
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02, vertical: screenHeight * 0.015),
                  minimumSize: Size(0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(screenWidth * 0.08)),
                    side: highContrast ? const BorderSide(color: Colors.black, width: 2) : BorderSide.none,
                  ),
                  foregroundColor: highContrast ? Colors.black : Colors.white,
                  textStyle: TextStyle(fontSize: 16 * fontSize),
                ),
                child: Text(
                  confirmButtonText,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
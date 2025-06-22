import 'package:flutter/material.dart';

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

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(screenWidth * 0.05), // Reso responsivo
      ),
      title: Text(
        titleText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: screenWidth * 0.05, // Reso responsivo
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ElevatedButton(
          onPressed: onCancel,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.07, vertical: screenHeight * 0.015), // Reso responsivo
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(screenWidth * 0.08)), // Reso responsivo
            ),
            foregroundColor: Colors.white,
          ),
          child: Text(cancelButtonText),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.07, vertical: screenHeight * 0.015), // Reso responsivo
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(screenWidth * 0.08)), // Reso responsivo
            ),
            foregroundColor: Colors.white,
          ),
          child: Text(confirmButtonText),
        ),
      ],
    );
  }
}
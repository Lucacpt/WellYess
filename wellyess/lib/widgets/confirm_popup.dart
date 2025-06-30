import 'package:flutter/material.dart';

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

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(w * 0.05),
      ),
      title: Text(
        titleText,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: w * 0.05,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: onCancel, // qui verrà chiamato il callback definito in med_section
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.07,
              vertical: h * 0.015,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(w * 0.08),
            ),
            foregroundColor: Colors.white,
          ),
          child: Text(cancelButtonText),
        ),
        ElevatedButton(
          onPressed: onConfirm, // idem per conferma
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.07,
              vertical: h * 0.015,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(w * 0.08),
            ),
            foregroundColor: Colors.white,
          ),
          child: Text(confirmButtonText),
        ),
      ],
    );
  }
}
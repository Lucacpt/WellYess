import 'package:flutter/material.dart';

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
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onConfirm != null) onConfirm!();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
            elevation: 6,
          ),
          child: const Icon(Icons.close, color: Colors.white, size: 28),
        ),
      ],
    );
  }
}
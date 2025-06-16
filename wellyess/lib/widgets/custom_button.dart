import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color; // parametro opzionale
  final double? fontSize; // parametro opzionale per la dimensione del font

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? const Color(0xFF5DB47F), // default verde
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize),
        textAlign: TextAlign.center,
      ),
    );
  }
}

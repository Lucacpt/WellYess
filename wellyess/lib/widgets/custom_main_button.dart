import 'package:flutter/material.dart';

class CustomMainButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const CustomMainButton({
    super.key,
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // prende tutta la larghezza disponibile
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 3,
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

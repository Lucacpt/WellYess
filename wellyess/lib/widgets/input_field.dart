import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  const InputField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.maxLines = 1,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    final Color bgColor = highContrast ? Colors.yellow.shade700 : Colors.white;
    final Color textColor = highContrast ? Colors.black : Colors.black87;
    final Color hintColor = highContrast ? Colors.black54 : Colors.grey;

    return Semantics(
      label: placeholder,
      hint: 'Campo di testo. Inserisci il testo richiesto.',
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
          border: highContrast
              ? Border.all(color: Colors.black, width: 2)
              : null,
        ),
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        child: TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: hintColor,
              fontSize: (screenWidth * 0.04 * fontSizeFactor).clamp(14.0, 22.0),
              fontWeight: highContrast ? FontWeight.bold : FontWeight.normal,
            ),
            border: InputBorder.none,
          ),
          style: TextStyle(
            fontSize: (screenWidth * 0.04 * fontSizeFactor).clamp(14.0, 22.0),
            color: textColor,
            fontWeight: highContrast ? FontWeight.bold : FontWeight.normal,
          ),
          cursorColor: textColor,
        ),
      ),
    );
  }
}
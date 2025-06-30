import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class DropdownField extends StatelessWidget {
  final List<String> options;
  final String? value;
  final String placeholder;
  final ValueChanged<String?> onChanged;

  const DropdownField({
    super.key,
    required this.options,
    required this.value,
    required this.placeholder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    return Semantics(
      label: placeholder,
      hint: 'Campo a scelta multipla. Premi per espandere le opzioni.',
      child: Container(
        decoration: BoxDecoration(
          color: highContrast ? Colors.yellow.shade700 : Colors.white,
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
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            hint: Text(
              placeholder,
              style: TextStyle(
                fontSize: screenWidth * 0.04 * fontSizeFactor,
                color: highContrast ? Colors.black : Colors.grey,
                fontWeight: highContrast ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            style: TextStyle(
              fontSize: screenWidth * 0.04 * fontSizeFactor,
              color: highContrast ? Colors.black : Colors.black,
              fontWeight: highContrast ? FontWeight.bold : FontWeight.normal,
            ),
            dropdownColor: highContrast ? Colors.yellow.shade700 : Colors.white,
            iconEnabledColor: highContrast ? Colors.black : Colors.grey.shade800,
            items: options
                .map(
                  (opt) => DropdownMenuItem<String>(
                    value: opt,
                    child: Semantics(
                      label: opt,
                      selected: value == opt,
                      child: Text(opt),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
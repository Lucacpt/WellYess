import 'package:flutter/material.dart';

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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04), // Reso responsivo
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03), // Reso responsivo
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            placeholder,
            style: TextStyle(
                fontSize: screenWidth * 0.04, color: Colors.grey), // Reso responsivo
          ),
          style: TextStyle(
              fontSize: screenWidth * 0.04, color: Colors.black), // Stile per gli item
          items: options
              .map(
                (opt) => DropdownMenuItem<String>(
                  value: opt,
                  child: Text(opt),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
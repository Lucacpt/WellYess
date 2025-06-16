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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            placeholder,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
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

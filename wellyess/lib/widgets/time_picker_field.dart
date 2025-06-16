import 'package:flutter/material.dart';

class TimePickerField extends StatelessWidget {
  final TimeOfDay? value;
  final String placeholder;
  final ValueChanged<TimeOfDay> onChanged;

  const TimePickerField({
    super.key,
    required this.value,
    required this.placeholder,
    required this.onChanged,
  });

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: value ?? TimeOfDay.now(),
    );
    if (picked != null && picked != value) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectTime(context),
      child: Container(
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value != null ? value!.format(context) : placeholder,
                style: TextStyle(
                  fontSize: 16,
                  color: value != null ? Colors.black : Colors.grey,
                ),
              ),
            ),
            const Icon(Icons.access_time, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

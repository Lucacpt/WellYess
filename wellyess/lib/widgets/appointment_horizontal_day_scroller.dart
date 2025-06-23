import 'package:flutter/material.dart';
import 'package:wellyess/models/appointment_model.dart'; // <— usa AppointmentModel
import 'package:intl/intl.dart'; // opzionale, per formattazioni

class HorizontalDayScroller extends StatelessWidget {
  final DateTime selectedDate;
  final List<AppointmentModel> allAppointments; // <— tipo corretto
  final ValueChanged<DateTime> onDaySelected;

  const HorizontalDayScroller({
    Key? key,
    required this.selectedDate,
    required this.allAppointments,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final days = List.generate(4, (i) => selectedDate.add(Duration(days: i - 1)));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((day) {
        final has = allAppointments.any((app) => DateUtils.isSameDay(app.dateTime, day));
        final isSel = DateUtils.isSameDay(day, selectedDate);
        return GestureDetector(
          onTap: () => onDaySelected(day),
          child: Column(
            children: [
              Text(DateFormat('E', 'it_IT').format(day)),
              Text(day.day.toString()),
              Container(width: 6, height: 6, decoration: BoxDecoration(color: has ? (isSel ? Colors.green : Colors.grey) : Colors.transparent, shape: BoxShape.circle)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
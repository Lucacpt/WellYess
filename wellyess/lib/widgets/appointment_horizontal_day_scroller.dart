import 'package:flutter/material.dart';
import 'package:wellyess/models/appointment_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class HorizontalDayScroller extends StatelessWidget {
  final DateTime selectedDate;
  final List<AppointmentModel> allAppointments;
  final ValueChanged<DateTime> onDaySelected;

  const HorizontalDayScroller({
    Key? key,
    required this.selectedDate,
    required this.allAppointments,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibilitaModel>();
    final fontSize = access.fontSizeFactor;
    final highContrast = access.highContrast;

    final days = List.generate(4, (i) => selectedDate.add(Duration(days: i - 1)));

    // Palette accessibile
    final Color selectedTextColor = highContrast ? Colors.black : Colors.white;
    final Color unselectedTextColor = Colors.black;
    final Color selectedBgColor = highContrast ? Colors.yellow.shade700 : const Color(0xFF5DB47F);
    final Color unselectedBgColor = Colors.transparent;

    // Limiti per i font
    double labelFont = (15 * fontSize).clamp(13.0, 18.0);
    double dayFont = (18 * fontSize).clamp(15.0, 22.0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((day) {
        final has = allAppointments.any((app) => DateUtils.isSameDay(app.dateTime, day));
        final isSel = DateUtils.isSameDay(day, selectedDate);

        final Color dayTextColor = isSel ? selectedTextColor : unselectedTextColor;
        final Color dayBgColor = isSel ? selectedBgColor : unselectedBgColor;
        final Color dotColor = has
            ? (isSel
                ? (highContrast ? Colors.black : Colors.green)
                : (highContrast ? Colors.black : Colors.grey))
            : Colors.transparent;

        return Semantics(
          label:
              "${DateFormat('EEEE', 'it_IT').format(day)}, ${day.day} ${DateFormat('MMMM', 'it_IT').format(day)}"
              "${isSel ? ', selezionato' : ''}"
              "${has ? ', appuntamento presente' : ', nessun appuntamento'}",
          button: true,
          selected: isSel,
          child: GestureDetector(
            onTap: () => onDaySelected(day),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: dayBgColor,
                borderRadius: BorderRadius.circular(12),
                border: isSel && highContrast
                    ? Border.all(color: Colors.black, width: 2)
                    : null,
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat('E', 'it_IT').format(day),
                    style: TextStyle(
                      fontSize: labelFont,
                      fontWeight: FontWeight.w600,
                      color: dayTextColor,
                    ),
                  ),
                  Text(
                    day.day.toString(),
                    style: TextStyle(
                      fontSize: dayFont,
                      fontWeight: FontWeight.bold,
                      color: dayTextColor,
                    ),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
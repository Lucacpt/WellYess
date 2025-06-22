import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/appointment_model.dart';

class HorizontalDayScroller extends StatelessWidget {
  final DateTime selectedDate;
  final List<Appointment> allAppointments;
  final ValueChanged<DateTime> onDaySelected;

  const HorizontalDayScroller({
    super.key,
    required this.selectedDate,
    required this.allAppointments,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    // MODIFICA: Genera una "finestra" di 4 giorni attorno alla data selezionata
    // invece dell'intera settimana.
    final List<DateTime> displayDays =
        List.generate(4, (index) => selectedDate.add(Duration(days: index - 1)));

    return SizedBox(
      height: 90, // Altezza fissa per il componente
      // MODIFICA: Sostituito ListView con una Row per un layout fisso a 4 elementi.
      // Questo previene l'overflow e la necessità di scorrere.
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: displayDays.map((day) {
          final isSelected = DateUtils.isSameDay(day, selectedDate);
          final hasAppointments = allAppointments
              .any((app) => DateUtils.isSameDay(app.dateTime, day));

          return GestureDetector(
            onTap: () => onDaySelected(day),
            child: Container(
              width: 65, // Larghezza fissa per ogni elemento
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green.shade100 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: Colors.green.shade600, width: 1.5)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E', 'it_IT').format(day).toUpperCase(), // LUN, MAR
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.green.shade900 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    day.day.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.green.shade900 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Indicatore appuntamento
                  Container(
                    height: 5,
                    width: 5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasAppointments
                          ? (isSelected ? Colors.green.shade700 : Colors.grey.shade500)
                          : Colors.transparent,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
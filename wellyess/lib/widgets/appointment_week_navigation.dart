import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekNavigator extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<int> onWeekChanged;

  const WeekNavigator({
    super.key,
    required this.selectedDate,
    required this.onWeekChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Calcola l'intervallo di 4 giorni da visualizzare.
    // Si basa sulla data attiva (`selectedDate`) per essere sempre coerente
    // con il giorno evidenziato nel selettore sottostante.
    DateTime startOfRange = selectedDate.subtract(const Duration(days: 1));
    DateTime endOfRange = selectedDate.add(const Duration(days: 2));

    String formattedRange =
        "${DateFormat('d MMM', 'it_IT').format(startOfRange)} - ${DateFormat('d MMM yyyy', 'it_IT').format(endOfRange)}";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            // Quando si preme, comunica al genitore di spostare il range
            // indietro di 4 giorni.
            onPressed: () => onWeekChanged(-4)),
        Text(formattedRange,
            style: TextStyle(
                fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500)),
        IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            // Quando si preme, comunica al genitore di spostare il range
            // in avanti di 4 giorni.
            onPressed: () => onWeekChanged(4)),
      ],
    );
  }
}
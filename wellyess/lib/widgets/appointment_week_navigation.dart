import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

// Widget che permette la navigazione tra settimane (o intervalli di giorni) per la lista appuntamenti
class WeekNavigator extends StatelessWidget {
  final DateTime selectedDate; // Data attualmente selezionata
  final ValueChanged<int> onWeekChanged; // Callback per cambiare settimana (o intervallo)

  const WeekNavigator({
    super.key,
    required this.selectedDate,
    required this.onWeekChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final access = context.watch<AccessibilitaModel>();
    final fontSize = access.fontSizeFactor;
    final highContrast = access.highContrast;

    // Calcola l'intervallo di 4 giorni da visualizzare (ieri, oggi, domani, dopodomani)
    DateTime startOfRange = selectedDate.subtract(const Duration(days: 1));
    DateTime endOfRange = selectedDate.add(const Duration(days: 2));

    // Formatta la stringa che mostra l'intervallo di giorni
    String formattedRange =
        "${DateFormat('d MMM', 'it_IT').format(startOfRange)} - ${DateFormat('d MMM yyyy', 'it_IT').format(endOfRange)}";

    // Limita la crescita del font centrale in base al fattore di accessibilità
    final double rangeFont = (screenWidth * 0.04 * fontSize).clamp(14.0, 20.0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Pulsante per andare all'intervallo precedente (indietro di 4 giorni)
        IconButton(
          icon: Icon(Icons.arrow_back_ios,
              size: (screenWidth * 0.06 * fontSize).clamp(18.0, 28.0),
              color: highContrast ? Colors.black : Colors.grey.shade800),
          onPressed: () => onWeekChanged(-4),
          tooltip: 'Settimana precedente',
        ),
        // Testo che mostra l'intervallo di giorni selezionato
        Expanded(
          child: Text(
            formattedRange,
            style: TextStyle(
              fontSize: rangeFont,
              fontWeight: FontWeight.w500,
              color: highContrast ? Colors.black : Colors.grey.shade800,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
        // Pulsante per andare all'intervallo successivo (avanti di 4 giorni)
        IconButton(
          icon: Icon(Icons.arrow_forward_ios,
              size: (screenWidth * 0.06 * fontSize).clamp(18.0, 28.0),
              color: highContrast ? Colors.black : Colors.grey.shade800),
          onPressed: () => onWeekChanged(4),
          tooltip: 'Settimana successiva',
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:wellyess/models/appointment_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

// Widget che mostra uno scroller orizzontale di giorni per selezionare la data degli appuntamenti
class HorizontalDayScroller extends StatelessWidget {
  final DateTime selectedDate; // Data attualmente selezionata
  final List<AppointmentModel> allAppointments; // Tutti gli appuntamenti disponibili
  final ValueChanged<DateTime> onDaySelected;   // Callback quando si seleziona un giorno

  const HorizontalDayScroller({
    Key? key,
    required this.selectedDate,
    required this.allAppointments,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Recupera impostazioni di accessibilità dal provider
    final access = context.watch<AccessibilitaModel>();
    final fontSize = access.fontSizeFactor;
    final highContrast = access.highContrast;

    // Genera una lista di 4 giorni: ieri, oggi, domani, dopodomani rispetto alla data selezionata
    final days = List.generate(4, (i) => selectedDate.add(Duration(days: i - 1)));

    // Palette colori accessibile per selezione e contrasto
    final Color selectedTextColor = highContrast ? Colors.black : Colors.white;
    final Color unselectedTextColor = Colors.black;
    final Color selectedBgColor = highContrast ? Colors.yellow.shade700 : const Color(0xFF5DB47F);
    final Color unselectedBgColor = Colors.transparent;

    // Limiti per i font in base al fattore di accessibilità
    double labelFont = (15 * fontSize).clamp(13.0, 18.0);
    double dayFont = (18 * fontSize).clamp(15.0, 22.0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((day) {
        // Verifica se ci sono appuntamenti in quel giorno
        final has = allAppointments.any((app) => DateUtils.isSameDay(app.dateTime, day));
        // Verifica se il giorno è quello selezionato
        final isSel = DateUtils.isSameDay(day, selectedDate);

        // Colori dinamici in base allo stato selezionato e accessibilità
        final Color dayTextColor = isSel ? selectedTextColor : unselectedTextColor;
        final Color dayBgColor = isSel ? selectedBgColor : unselectedBgColor;
        final Color dotColor = has
            ? (isSel
                ? (highContrast ? Colors.black : Colors.green)
                : (highContrast ? Colors.black : Colors.grey))
            : Colors.transparent;

        // Semantics per accessibilità: descrive il giorno, se selezionato e se ci sono appuntamenti
        return Semantics(
          label:
              "${DateFormat('EEEE', 'it_IT').format(day)}, ${day.day} ${DateFormat('MMMM', 'it_IT').format(day)}"
              "${isSel ? ', selezionato' : ''}"
              "${has ? ', appuntamento presente' : ', nessun appuntamento'}",
          button: true,
          selected: isSel,
          child: GestureDetector(
            onTap: () => onDaySelected(day), // Seleziona il giorno al tap
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
                  // Giorno della settimana (es: "Lun")
                  Text(
                    DateFormat('E', 'it_IT').format(day),
                    style: TextStyle(
                      fontSize: labelFont,
                      fontWeight: FontWeight.w600,
                      color: dayTextColor,
                    ),
                  ),
                  // Numero del giorno (es: "23")
                  Text(
                    day.day.toString(),
                    style: TextStyle(
                      fontSize: dayFont,
                      fontWeight: FontWeight.bold,
                      color: dayTextColor,
                    ),
                  ),
                  // Puntino che indica la presenza di appuntamenti
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
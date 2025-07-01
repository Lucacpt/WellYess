import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wellyess/models/appointment_model.dart';
import '../screens/dettagli_visita.dart';
import 'custom_button.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;

  const AppointmentCard({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibilitaModel>();
    final fontSize = access.fontSizeFactor;
    final highContrast = access.highContrast;

    final dateStr = DateFormat('d MMM yyyy', 'it_IT').format(appointment.data);
    final timeStr = DateFormat('HH:mm').format(appointment.ora);

    return Semantics(
      label:
          'Visita: ${appointment.tipoVisita}, il $dateStr alle $timeStr. Premi dettagli per maggiori informazioni.',
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: highContrast ? Colors.black : Colors.transparent, // bordo nero solo se contrasto attivo
            width: highContrast ? 2 : 0,
          ),
        ),
        child: ListTile(
          title: Text(
            appointment.tipoVisita,
            style: TextStyle(
              fontSize: 18 * fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          subtitle: Text(
            "$dateStr  •  $timeStr",
            style: TextStyle(
              fontSize: 15 * fontSize,
              color: Colors.black,
            ),
          ),
          trailing: Semantics(
            label: 'Vai ai dettagli della visita',
            button: true,
            child: CustomButton(
              text: 'Dettagli',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DettagliVisitaScreen(appointment: {
                      'tipoVisita': appointment.tipoVisita,
                      'luogo': appointment.luogo,
                      'data': dateStr,
                      'ora': timeStr,
                      'note': appointment.note,
                    }),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wellyess/models/appointment_model.dart';
import '../screens/dettagli_visita.dart';
import 'custom_button.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/widgets/tappable_reader.dart';
import 'package:wellyess/models/accessibilita_model.dart';

// Widget che rappresenta una card per visualizzare un appuntamento/visita
class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment; // Modello dati dell'appuntamento

  const AppointmentCard({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Recupera impostazioni di accessibilità dal provider
    final access = context.watch<AccessibilitaModel>();
    final fontSize = access.fontSizeFactor;
    final highContrast = access.highContrast;

    // Formatta la data e l'ora per la visualizzazione
    final dateStr = DateFormat('d MMM yyyy', 'it_IT').format(appointment.data);
    final timeStr = DateFormat('HH:mm').format(appointment.ora);

    return Card(
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
        // Titolo della visita (es: "Visita cardiologica")
        title: TappableReader(
          label: appointment.tipoVisita,
          child: Text(
            appointment.tipoVisita,
            style: TextStyle(
              fontSize: 18 * fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Sottotitolo con data e ora della visita
        subtitle: TappableReader(
          label: "$dateStr • $timeStr",
          child: Text(
            "$dateStr  •  $timeStr",
            style: TextStyle(
              fontSize: 15 * fontSize,
              color: Colors.black,
            ),
          ),
        ),
        // Pulsante per vedere i dettagli della visita
        trailing: TappableReader(
          label: 'Dettagli visita',
          child: CustomButton(
            text: 'Dettagli',
            onPressed: () {
              // Naviga alla schermata dei dettagli della visita passando i dati necessari
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
    );
  }
}
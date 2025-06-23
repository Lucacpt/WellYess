import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wellyess/models/appointment_model.dart'; // <— usa AppointmentModel
import '../screens/dettagli_visita.dart';
import 'custom_button.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointment; // <— tipo corretto

  const AppointmentCard({Key? key, required this.appointment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('d MMM yyyy', 'it_IT').format(appointment.data);
    final timeStr = DateFormat('HH:mm').format(appointment.ora);
    return Card(
      child: ListTile(
        title: Text(appointment.tipoVisita),
        subtitle: Text("$dateStr  •  $timeStr"),
        trailing: CustomButton(text: 'Dettagli', onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) =>
            DettagliVisitaScreen(appointment: {
              'tipoVisita': appointment.tipoVisita,
              'luogo': appointment.luogo,
              'data': dateStr,
              'ora': timeStr,
              'note': appointment.note,
            })
          ));
        }),
      ),
    );
  }
}
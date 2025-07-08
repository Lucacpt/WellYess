import 'package:flutter/material.dart';
import 'package:wellyess/models/appointment_model.dart';
import 'appointment_card.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

// Widget che mostra la lista degli appuntamenti/visite
class AppointmentList extends StatelessWidget {
  final List<AppointmentModel> appointments; // Lista degli appuntamenti da visualizzare

  const AppointmentList({Key? key, required this.appointments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Recupera impostazioni di accessibilità dal provider
    final access = context.watch<AccessibilitaModel>();
    final fontSize = access.fontSizeFactor;
    final highContrast = access.highContrast;

    // Se la lista è vuota, mostra un messaggio informativo
    if (appointments.isEmpty) {
      return Center(
        child: Text(
          "Nessun appuntamento per oggi",
          style: TextStyle(
            fontSize: 16 * fontSize,
            color: highContrast ? Colors.black : Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    // Altrimenti mostra la lista degli appuntamenti tramite ListView
    return ListView.builder(
      itemCount: appointments.length, // Numero di appuntamenti
      itemBuilder: (context, index) {
        // Per ogni appuntamento crea una AppointmentCard
        return AppointmentCard(appointment: appointments[index]);
      },
    );
  }
}
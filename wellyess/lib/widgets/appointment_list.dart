import 'package:flutter/material.dart';
import 'package:wellyess/models/appointment_model.dart';
import 'appointment_card.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class AppointmentList extends StatelessWidget {
  final List<AppointmentModel> appointments;

  const AppointmentList({Key? key, required this.appointments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibilitaModel>();
    final fontSize = access.fontSizeFactor;
    final highContrast = access.highContrast;

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
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return AppointmentCard(appointment: appointments[index]);
      },
    );
  }
}
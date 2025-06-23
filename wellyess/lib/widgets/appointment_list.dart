import 'package:flutter/material.dart';
import 'package:wellyess/models/appointment_model.dart'; // <— usa AppointmentModel
import 'appointment_card.dart';

class AppointmentList extends StatelessWidget {
  final List<AppointmentModel> appointments; // <— tipo corretto

  const AppointmentList({Key? key, required this.appointments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return Center(
        child: Text("Nessun appuntamento per oggi", style: TextStyle(fontSize: 16, color: Colors.grey)),
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
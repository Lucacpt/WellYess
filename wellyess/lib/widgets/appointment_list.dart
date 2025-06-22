import 'package:flutter/material.dart';
import '../../models/appointment_model.dart';
import 'appointment_card.dart';

class AppointmentList extends StatelessWidget {
  final List<Appointment> appointments;

  const AppointmentList({super.key, required this.appointments});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (appointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_outlined,
                size: screenWidth * 0.15, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text("Nessun appuntamento per oggi",
                style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    color: Colors.grey.shade600)),
          ],
        ),
      );
    }

    // MODIFICA: Il widget deve essere un ListView.builder per essere scorrevole
    // all'interno del widget Expanded.
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return AppointmentCard(appointment: appointments[index]);
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/appointment_model.dart';
import '../../screens/dettagli_visita.dart';
import 'custom_button.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // MODIFICA: Le chiavi della mappa ora corrispondono esattamente
    // a quelle usate nella schermata DettagliVisitaScreen.
    final appointmentMap = {
      "tipoVisita": appointment.tipoVisita,
      "luogo": appointment.luogo,
      "data": DateFormat('d MMMM yyyy', 'it_IT').format(appointment.data),
      "ora": DateFormat('HH:mm').format(appointment.ora),
      "medico": appointment.medico,
    };

    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.3),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DettagliVisitaScreen(appointment: appointmentMap)));
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.02, horizontal: screenWidth * 0.04),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appointment.tipoVisita,
                        style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: screenHeight * 0.005),
                    Text(appointment.luogo,
                        style: TextStyle(
                            fontSize: screenWidth * 0.038,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87)),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('HH:mm').format(appointment.ora),
                      style: TextStyle(
                          fontSize: screenWidth * 0.055,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: screenHeight * 0.005),
                  AbsorbPointer(
                    child: CustomButton(
                        text: 'Dettagli',
                        color: const Color(0xFF5DB47F),
                        onPressed: () {},
                        fontSize: screenWidth * 0.038),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
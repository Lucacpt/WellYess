import 'package:flutter/material.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/custom_main_button.dart';

class SosDetailsScreen extends StatelessWidget {
  const SosDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BaseLayout(
      userType: UserType.caregiver, // Questa è una vista per il caregiver
      onBackPressed: () => Navigator.of(context).pop(),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 24.0).copyWith(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Emergenza',
              style: TextStyle(
                fontSize: screenWidth * 0.07,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: 30),
            Text(
              'Richiesta di\nSoccorso Ricevuto',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Text(
              'Posizione attuale di Michele Verdi',
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.black,
              ),
            ),

           // ...existing code...
            SizedBox(height: screenHeight * 0.02),


            // MODIFICA: Aggiunto un Container per creare l'ombra
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5), // changes position of shadow
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(
                  'assets/images/mappa_anziano.png', // Assicurati di avere questa immagine
                  width: double.infinity,
                  height: screenHeight * 0.2,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Spacer(),
           
            // Pulsante "Chiama i Soccorsi"
            CustomMainButton(
              text: 'Chiama i Soccorsi',
              icon: Icons.call,
              color: const Color(0xFFC63E3E),
              onTap: () {
                // Logica per chiamare i soccorsi (es. usando il package url_launcher)
              },
            ),

          ],
        ),
      ),
    );
  }
}
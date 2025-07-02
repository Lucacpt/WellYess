import 'package:flutter/material.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/custom_main_button.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class SosDetailsScreen extends StatelessWidget {
  const SosDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Accessibilità
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    return BaseLayout(
      pageTitle: 'Emergenza', // ← aggiunto
      userType: UserType.caregiver,
      onBackPressed: () => Navigator.of(context).pop(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // HEADER FISSO
          SizedBox(height: screenHeight * 0.01),
          Text(
            'Emergenza',
            style: TextStyle(
              fontSize: (screenWidth * 0.07 * fontSizeFactor).clamp(22.0, 40.0),
              fontWeight: FontWeight.bold,
              color: highContrast ? Colors.black : Colors.black87,
            ),
          ),
          Divider(
            height: 30,
            color: highContrast ? Colors.black : Colors.grey,
            thickness: 1.2,
          ),
          // CONTENUTO SCORRIBILE
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Richiesta di\nSoccorso Ricevuto',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: (screenWidth * 0.06 * fontSizeFactor).clamp(18.0, 30.0),
                        fontWeight: FontWeight.bold,
                        color: highContrast ? Colors.black : Colors.black87,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Text(
                      'Posizione attuale di Michele Verdi',
                      style: TextStyle(
                        fontSize: (screenWidth * 0.04 * fontSizeFactor).clamp(13.0, 27.0),
                        color: highContrast ? Colors.black : Colors.black,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    // Mappa con ombra
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Image.asset(
                          'assets/images/mappa_anziano.png',
                          width: double.infinity,
                          height: screenHeight * 0.2,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // FOOTER FISSO
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: CustomMainButton(
              text: 'Chiama i Soccorsi',
              icon: Icons.call,
              color: const Color(0xFFC63E3E),
              onTap: () {
                // Logica per chiamare i soccorsi
              },
            ),
          ),
        ],
      ),
    );
  }
}
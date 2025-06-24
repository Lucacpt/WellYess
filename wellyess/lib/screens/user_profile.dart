import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/info_row.dart';

class ProfiloUtente extends StatelessWidget {
  // MODIFICA: Aggiunto un parametro per forzare la vista dell'anziano
  final bool forceElderView;

  const ProfiloUtente({
    super.key,
    this.forceElderView = false, // Di default è falso
  });

  Future<String?> _getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userType');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return FutureBuilder<String?>(
      future: _getUserType(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Determina se l'utente loggato è un caregiver
        final loggedInUserIsCaregiver =
            snapshot.data == UserType.caregiver.toString();

        // MODIFICA: La decisione su cosa mostrare ora dipende da forceElderView
        final bool showElderProfile = forceElderView || !loggedInUserIsCaregiver;

        final userTypeForLayout =
            loggedInUserIsCaregiver ? UserType.caregiver : UserType.elder;

        final String profileImageAsset = showElderProfile
            ? 'assets/images/elder_profile_pic.png'
            : 'assets/images/svetlana.jpg';
        final String name =
            showElderProfile ? 'Michele Verdi' : 'Svetlana Nowak';

        return BaseLayout(
          currentIndex: 2,
          // L'header mostra sempre il profilo dell'utente loggato
          userType: userTypeForLayout,
          onBackPressed: () {
            Navigator.pop(context);
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    // MODIFICA: Il titolo cambia in base al contesto
                    forceElderView ? 'Profilo Assistito' : 'Profilo',
                    style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(thickness: 1, color: Colors.grey),
                SizedBox(height: screenHeight * 0.025),
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.125,
                        backgroundImage: AssetImage(profileImageAsset),
                      ),
                      SizedBox(height: screenHeight * 0.012),
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.025),
                // MODIFICA: La logica if/else ora usa la nuova variabile
                if (!showElderProfile) ...[
                  // Mostra i dati del caregiver solo se non stiamo forzando la vista anziano
                  const InfoRow(label: 'Data nascita', value: '30 Ott 1991'),
                  const Divider(thickness: 1, color: Colors.grey),
                  SizedBox(height: screenHeight * 0.018),
                  const InfoRow(label: 'Sesso', value: 'Femmina'),
                  const Divider(thickness: 1, color: Colors.grey),
                  SizedBox(height: screenHeight * 0.018),
                  const InfoRow(
                      label: 'Assistito', value: 'Michele Verdi'),
                  const Divider(thickness: 1, color: Colors.grey),
                  SizedBox(height: screenHeight * 0.018),
                  const InfoRow(
                      label: 'Email', value: 'federica.rossi@email.com'),
                  const Divider(thickness: 1, color: Colors.grey),
                  SizedBox(height: screenHeight * 0.018),
                  const InfoRow(label: 'Telefono', value: '333 1234567'),
                  const Divider(thickness: 1, color: Colors.grey),
                ] else ...[
                  // Mostra i dati dell'anziano in tutti gli altri casi
                  const InfoRow(label: 'Data nascita', value: '15 Mag 1948'),
                  const Divider(thickness: 1, color: Colors.grey),
                  SizedBox(height: screenHeight * 0.018),
                  const InfoRow(label: 'Sesso', value: 'Maschile'),
                  const Divider(thickness: 1, color: Colors.grey),
                  SizedBox(height: screenHeight * 0.018),
                  const InfoRow(label: 'Allergie', value: 'Polline'),
                  const Divider(thickness: 1, color: Colors.grey),
                  SizedBox(height: screenHeight * 0.018),
                  const InfoRow(label: 'Intolleranze', value: 'Lattosio'),
                  const Divider(thickness: 1, color: Colors.grey),
                  SizedBox(height: screenHeight * 0.018),
                  const InfoRow(label: 'Gruppo sanguigno', value: 'A+'),
                  const Divider(thickness: 1, color: Colors.grey),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
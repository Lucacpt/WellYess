import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/info_row.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import 'package:wellyess/widgets/tappable_reader.dart';

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

    // Accessibilità
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

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
          pageTitle: forceElderView ? 'Profilo Assistito' : 'Profilo', // ← aggiunto
          currentIndex: 2,
          // L'header mostra sempre il profilo dell'utente loggato
          userType: userTypeForLayout,
          onBackPressed: () {
            Navigator.pop(context);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER FISSO
              SizedBox(height: screenHeight * 0.025),
              Center(
                child: TappableReader(
                  label: forceElderView
                      ? 'Titolo pagina Profilo Assistito'
                      : 'Titolo pagina Profilo',
                  child: Text(
                    forceElderView ? 'Profilo Assistito' : 'Profilo',
                    style: TextStyle(
                      fontSize: (screenWidth * 0.08 * fontSizeFactor)
                          .clamp(22.0, 40.0),
                      fontWeight: FontWeight.bold,
                      color: highContrast ? Colors.black : Colors.black87,
                    ),
                  ),
                ),
              ),
              Divider(
                color: highContrast ? Colors.black : Colors.grey,
                thickness: 1,
              ),
              // CONTENUTO SCORRIBILE
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.03),
                      Center(
                        child: Column(
                          children: [
                            TappableReader(
                              label: showElderProfile
                                  ? 'Immagine profilo assistito'
                                  : 'Immagine profilo caregiver',
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: highContrast
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: highContrast ? 3 : 0,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: screenWidth * 0.125,
                                  backgroundImage: AssetImage(profileImageAsset),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            TappableReader(
                              label: showElderProfile
                                  ? 'Nome assistito: $name'
                                  : 'Nome caregiver: $name',
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontSize: (screenWidth * 0.07 * fontSizeFactor)
                                      .clamp(18.0, 35.0),
                                  fontWeight: FontWeight.bold,
                                  color: highContrast ? Colors.black : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // MODIFICA: La logica if/else ora usa la nuova variabile
                      if (!showElderProfile) ...[
                        // Mostra i dati del caregiver solo se non stiamo forzando la vista anziano
                        TappableReader(
                          label: 'Data nascita assistente: 13 novembre 1991',
                          child: const InfoRow(label: 'Data Nascita', value: '13/11/\'91'),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        SizedBox(height: screenHeight * 0.018),
                        TappableReader(
                          label: 'Sesso assistente: Femmina',
                          child: const InfoRow(label: 'Sesso', value: 'Femmina'),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        SizedBox(height: screenHeight * 0.018),
                        TappableReader(
                          label: 'Assistito: Michele Verdi',
                          child: const InfoRow(
                              label: 'Assistito', value: 'Michele Verdi'),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        SizedBox(height: screenHeight * 0.018),
                        TappableReader(
                          label: 'Email assistente: nowak@ex.com',
                          child: const InfoRow(label: 'Email', value: 'nowak@ex.com'),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        SizedBox(height: screenHeight * 0.018),
                        TappableReader(
                          label: 'Telefono assistente: 3331234567',
                          child: const InfoRow(label: 'Telefono', value: '3331234567'),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ] else ...[
                        // Mostra i dati dell'anziano in tutti gli altri casi
                        TappableReader(
                          label: 'Data nascita assistito: 15 maggio 1948',
                          child: const InfoRow(label: 'Data nascita', value: '15/05/\'48'),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        SizedBox(height: screenHeight * 0.018),
                        TappableReader(
                          label: 'Sesso assistito: Maschile',
                          child: const InfoRow(label: 'Sesso', value: 'Maschile'),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        SizedBox(height: screenHeight * 0.018),
                        TappableReader(
                          label: 'Allergie assistito: Polline',
                          child: const InfoRow(label: 'Allergie', value: 'Polline'),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        SizedBox(height: screenHeight * 0.018),
                        TappableReader(
                          label: 'Intolleranze assistito: Lattosio',
                          child: const InfoRow(label: 'Intolleranze', value: 'Lattosio'),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        SizedBox(height: screenHeight * 0.018),
                        TappableReader(
                          label: 'Gruppo sanguigno assistito: A',
                          child: const InfoRow(label: 'Gruppo sanguigno', value: 'A'),
                        ),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
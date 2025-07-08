import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/info_row.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import 'package:wellyess/widgets/tappable_reader.dart';

// Schermata che mostra il profilo dell'utente (anziano o caregiver)
class ProfiloUtente extends StatelessWidget {
  // Parametro per forzare la vista dell'anziano anche se l'utente loggato è un caregiver
  final bool forceElderView;

  const ProfiloUtente({
    super.key,
    this.forceElderView = false, // Di default è falso
  });

  // Recupera il tipo di utente salvato nelle preferenze
  Future<String?> _getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userType');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Accessibilità: recupera i valori dal provider
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    // Usa FutureBuilder per attendere il recupero del tipo utente
    return FutureBuilder<String?>(
      future: _getUserType(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Mostra loader durante il caricamento
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Determina se l'utente loggato è un caregiver
        final loggedInUserIsCaregiver =
            snapshot.data == UserType.caregiver.toString();

        // Se forzato o se l'utente NON è caregiver, mostra il profilo dell'anziano
        final bool showElderProfile = forceElderView || !loggedInUserIsCaregiver;

        // Imposta il tipo utente per il layout (serve per la barra in alto)
        final userTypeForLayout =
            loggedInUserIsCaregiver ? UserType.caregiver : UserType.elder;

        // Scegli l'immagine e il nome in base al profilo da mostrare
        final String profileImageAsset = showElderProfile
            ? 'assets/images/elder_profile_pic.png'
            : 'assets/images/svetlana.jpg';
        final String name =
            showElderProfile ? 'Michele Verdi' : 'Svetlana Nowak';

        return BaseLayout(
          pageTitle: forceElderView ? 'Profilo Assistito' : 'Profilo', // Titolo della pagina
          currentIndex: 2,
          userType: userTypeForLayout,
          onBackPressed: () {
            Navigator.pop(context);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER FISSO: Titolo pagina
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
              // CONTENUTO SCORRIBILE: Dati profilo
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.03),
                      Center(
                        child: Column(
                          children: [
                            // Immagine profilo
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
                            // Nome profilo
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
                      // Se il profilo è del caregiver, mostra i dati del caregiver
                      if (!showElderProfile) ...[
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
                        // Se il profilo è dell'anziano, mostra i dati dell'anziano
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
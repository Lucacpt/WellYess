import 'package:flutter/material.dart';
import '../widgets/base_layout.dart';
import 'aggiungi_caregiver.dart';
import '../widgets/confirm_popup.dart';
import '../widgets/custom_main_button.dart';
import 'package:wellyess/widgets/tappable_reader.dart';

// Pagina che mostra il profilo del caregiver
class CaregiverProfilePage extends StatelessWidget {
  const CaregiverProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ottieni le dimensioni dello schermo per layout responsivo
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BaseLayout(
      pageTitle: 'Profilo Caregiver', // Titolo della pagina nella barra superiore
      currentIndex: 1,
      onBackPressed: () => Navigator.of(context).pop(), // Azione per il tasto indietro
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04)
            .copyWith(bottom: screenHeight * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Sezione principale che si espande e diventa scorrevole se necessario
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Ruolo visualizzato in alto
                    Align(
                      alignment: Alignment.topCenter,
                      child: TappableReader(
                        label: 'Ruolo: Assistente',
                        child: Text(
                          'Assistente',
                          style: TextStyle(
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    SizedBox(height: screenHeight * 0.035),
                    // Immagine del caregiver
                    Center(
                      child: TappableReader(
                        label: 'Immagine del caregiver',
                        child: CircleAvatar(
                          radius: screenWidth * 0.18,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage:
                              const AssetImage('assets/images/caregiver.png'),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    // Nome del caregiver
                    Center(
                      child: TappableReader(
                        label: 'Nome caregiver: Svetlana Nowak',
                        child: Text(
                          'Svetlana Nowak',
                          style: TextStyle(
                            fontSize: screenWidth * 0.075,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.07),
                    // Riga telefono
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TappableReader(
                          label: 'Etichetta Telefono',
                          child: Text(
                            'Telefono',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                        ),
                        TappableReader(
                          label: 'Telefono: 3202356890',
                          child: Text(
                            '3202356890',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 1, thickness: 1),
                    SizedBox(height: screenHeight * 0.035),
                    // Riga email
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TappableReader(
                          label: 'Etichetta Email',
                          child: Text(
                            'Email',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                        ),
                        TappableReader(
                          label: 'Email: s.nowak@email.com',
                          child: Text(
                            's.nowak@email.com',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 1, thickness: 1),
                  ],
                ),
              ),
            ),
            // Pulsante fisso in fondo per eliminare il caregiver
            SizedBox(height: screenHeight * 0.02),
            TappableReader(
              label: 'Bottone Elimina caregiver',
              child: CustomMainButton(
                text: 'Elimina',
                color: Colors.red,
                onTap: () {
                  // Mostra un popup di conferma prima di eliminare il caregiver
                  showDialog(
                    context: context,
                    builder: (BuildContext ctx) {
                      return ConfirmDialog(
                        titleText:
                            'Vuoi davvero Eliminare?\nL’azione è irreversibile',
                        cancelButtonText: 'No, Esci',
                        confirmButtonText: 'Sì, Elimina',
                        onCancel: () {
                          Navigator.of(ctx).pop();
                        },
                        onConfirm: () {
                          Navigator.of(ctx).pop();
                          // Dopo l'eliminazione, reindirizza alla pagina di aggiunta caregiver
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const AggiungiCaregiverPage(),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
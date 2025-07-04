import 'package:flutter/material.dart';
import '../widgets/base_layout.dart';
import 'aggiungi_caregiver.dart';
import '../widgets/confirm_popup.dart';
import '../widgets/custom_main_button.dart';
import 'package:wellyess/widgets/tappable_reader.dart';

class CaregiverProfilePage extends StatelessWidget {
  const CaregiverProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Otteniamo le dimensioni dello schermo
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BaseLayout(
      pageTitle: 'Profilo Caregiver', // ← aggiunto
      currentIndex: 1,
      onBackPressed: () => Navigator.of(context).pop(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04)
            .copyWith(bottom: screenHeight * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 3. Questa sezione si espande e diventa scorrevole SOLO SE necessario
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: TappableReader(
                        label: 'Ruolo: Assistente',
                        child: Text(
                          'Assistente',
                          style: TextStyle(
                            // 2. Ogni dimensione è relativa allo schermo
                            fontSize: screenWidth * 0.08,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    SizedBox(height: screenHeight * 0.035),
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
            // 4. Il pulsante rimane sempre visibile in fondo
            SizedBox(height: screenHeight * 0.02),
            TappableReader(
              label: 'Bottone Elimina caregiver',
              child: CustomMainButton(
                text: 'Elimina',
                color: Colors.red,
                onTap: () {
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
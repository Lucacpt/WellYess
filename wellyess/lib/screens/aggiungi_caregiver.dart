import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/base_layout.dart';

class AggiungiCaregiverPage extends StatelessWidget {
  const AggiungiCaregiverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      pageTitle: 'Caregiver', // ← aggiunto
      currentIndex: 0,
      onBackPressed: () => Navigator.of(context).pop(),
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding esterno principale della pagina
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Titolo in alto
            const Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Caregiver',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            // Fine Titolo

            const SizedBox(height: 80), 

            Padding(
              // Riduci o rimuovi il padding orizzontale qui per allargare il pulsante
              padding: const EdgeInsets.symmetric(horizontal: 0), // Impostato a 0 per la massima larghezza
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/icons/add_Caregiver.svg',
                    height: 150,
                    width: 150,
                    colorFilter: ColorFilter.mode(Colors.black87, BlendMode.srcIn),
                    placeholderBuilder: (BuildContext context) => Container(
                        padding: const EdgeInsets.all(30.0),
                        child: const CircularProgressIndicator()),
                  ),
                  const SizedBox(height: 80), // Spazio tra l'immagine e il pulsante

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Logica per aggiungere un caregiver
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/add_icon.svg',
                        height: 15,
                        width: 15,
                        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                      label: const Text(
                        'Aggiungi Caregiver',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: Colors.green.shade500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: const TextStyle(
                           fontSize: 20,
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
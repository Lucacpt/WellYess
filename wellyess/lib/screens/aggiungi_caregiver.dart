import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/base_layout.dart';

// Pagina per aggiungere un nuovo caregiver
class AggiungiCaregiverPage extends StatelessWidget {
  const AggiungiCaregiverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      pageTitle: 'Caregiver', // Titolo della pagina mostrato nella barra superiore
      currentIndex: 0, // Indice della pagina nella navbar (se usata)
      onBackPressed: () => Navigator.of(context).pop(), // Azione per il tasto indietro
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding esterno principale della pagina
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Titolo in alto centrato
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
            const Divider(), // Linea divisoria sotto il titolo

            const SizedBox(height: 80), // Spazio tra titolo e contenuto

            // Contenitore per immagine e pulsante
            Padding(
              // Padding orizzontale impostato a 0 per allargare il pulsante
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Immagine SVG che rappresenta l'aggiunta di un caregiver
                  SvgPicture.asset(
                    'assets/icons/add_Caregiver.svg',
                    height: 150,
                    width: 150,
                    colorFilter: ColorFilter.mode(Colors.black87, BlendMode.srcIn),
                    placeholderBuilder: (BuildContext context) => Container(
                        padding: const EdgeInsets.all(30.0),
                        child: const CircularProgressIndicator()),
                  ),
                  const SizedBox(height: 80), // Spazio tra immagine e pulsante

                  // Pulsante per aggiungere un caregiver
                  SizedBox(
                    width: double.infinity, // Occupa tutta la larghezza disponibile
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Qui va la logica per aggiungere un caregiver
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
                        padding: const EdgeInsets.symmetric(vertical: 18), // Altezza del pulsante
                        backgroundColor: Colors.green.shade500, // Colore di sfondo
                        foregroundColor: Colors.white, // Colore del testo/icona
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // Bordi arrotondati
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
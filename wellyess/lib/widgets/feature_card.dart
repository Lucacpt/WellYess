import 'package:flutter/material.dart';

/*
  FeatureCard è un widget riutilizzabile
  Campi: 
    - icon: widget che rappresenta l'icona della funzionalità
    - label: stringa che rappresenta il nome della funzionalità
    - onTap: callback opzionale che viene chiamata quando l'utente tocca la card
*/ 
class FeatureCard extends StatelessWidget {
  // Icona da mostrare nella card (ad esempio, un'icona SVG o un'icona di Flutter)
  final Widget icon;
  // Testo da mostrare sotto l'icona
  final String label;
  // Funzione opzionale da chiamare quando l'utente tocca la card
  final VoidCallback? onTap;

  // Costruttore della FeatureCard che richiede l'icona, l'etichetta e un callback opzionale
  const FeatureCard({
    Key? key,     // Opzionale e può essere utilizzato per identificare univocamente il widget
    required this.icon,
    required this.label,
    this.onTap,
  }) : super(key: key);

  // Il metodo build costruisce l'interfaccia utente del widget
  @override
  Widget build(BuildContext context) {
    // Restituisce un widget Card con ombra e bordi arrotondati
    return Card(
      elevation: 5, // Altezza dell'ombra della card
      shadowColor: Colors.grey.shade300,  // Colore dell'ombra della card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),   // Bordo arrotondato della card
      // Il widget InkWell permette di rilevare i tocchi e applicare un effetto visivo
      child: InkWell(
        onTap: onTap,  // Gestisce il tap sulla card, se onTap è fornito
        borderRadius: BorderRadius.circular(15),  // Arrotonda i bordi dell'effetto InkWell
        // Padding interno della card
        child: Padding(
          padding: const EdgeInsets.all(15),  // Spazio interno della card
          // Colonna per allineare l'icona e il testo al centro
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,  // Allinea gli elementi al centro verticalmente
            // Allinea gli elementi al centro orizzontalmente
            children: [
              icon,
              const SizedBox(height: 5), // Spazio tra l'icona e il testo
              // Testo che mostra il label della funzionalità
              Text(
                label,
                textAlign: TextAlign.center,  // Allinea il testo al centro
                // Stile del testo
                style: const TextStyle( 
                  fontSize: 17,
                  fontWeight: FontWeight.bold,  // Peso del font
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

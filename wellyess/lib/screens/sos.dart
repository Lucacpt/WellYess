import 'package:flutter/material.dart';
import '../widgets/base_layout.dart';

class EmergenzaScreen extends StatelessWidget {
  const EmergenzaScreen({super.key});

  // Modifica la firma del metodo per restituire Future<void>
  Future<void> _showCaregiverNotifiedDialog(BuildContext context) {
    // Restituisci il Future da showDialog
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          contentPadding: const EdgeInsets.all(20.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'Il Tuo Caregiver È Stato Avvisato',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Chiude solo il dialogo
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 28),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      onBackPressed: () => Navigator.of(context).pop(),
      child: Column(
        children: [
          const Text(
            'Emergenza',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 5),
          Divider(color: Colors.grey.shade300),

          const Spacer(flex: 2),

          GestureDetector(
            onTap: () {
              _showCaregiverNotifiedDialog(context).then((_) {
                // Questo codice viene eseguito DOPO che il dialogo è stato chiuso.
                // Ora chiudiamo EmergenzaScreen per tornare alla pagina precedente (HomePage).
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
                // Se invece volessi SEMPRE tornare alla HomePage e pulire lo stack:
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   MaterialPageRoute(builder: (context) => const HomePage()), // Assicurati di aver importato HomePage
                //   (Route<dynamic> route) => false,
                // );
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.width * 0.7,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.black, width: 3),
              ),
              child: const Center(
                child: Text(
                  'SOS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),

          const Spacer(flex: 3),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // Azione per "Aggiungi Alla Schermata Di Home"
              },
              icon: const Icon(
                Icons.home_filled,
                color: Colors.white,
                size: 30,
              ),
              label: const Text(
                'Aggiungi Alla Schermata Di Home',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade400,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:wellyess/screens/sos_details_screen.dart';

class SosRequestCard extends StatelessWidget {
  final String personName;
  final String timestamp;
  final bool isNew;

  const SosRequestCard({
    super.key,
    required this.personName,
    required this.timestamp,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      color: Colors.white,
      elevation: 5,
      clipBehavior: Clip.antiAlias, // Assicura che l'InkWell rispetti i bordi
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: isNew ? Colors.red.shade300 : Colors.transparent,
          width: 1.5,
        ),
      ),
      // MODIFICA: Aggiunto InkWell per rendere la card cliccabile
      child: InkWell(
        onTap: isNew
            ? () {
                // Naviga alla pagina di dettaglio SOS
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SosDetailsScreen(),
                  ),
                );
              }
            : null, // Rende la card non cliccabile se non è nuova
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                isNew
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_outline,
                color: isNew ? Colors.red.shade700 : Colors.green,
                size: screenWidth * 0.1,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      personName,
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timestamp,
                      style: TextStyle(
                        fontSize: screenWidth * 0.038,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // MODIFICA: Sostituito il pulsante con un'icona o testo
              if (isNew)
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade600,
                  size: screenWidth * 0.05,
                )
              else
                Text(
                  'Gestita',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: screenWidth * 0.038,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback? onTap;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Otteniamo la larghezza dello schermo per rendere responsive gli elementi interni
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      color: Colors.white,
      elevation: 5,
      shadowColor: Colors.grey.shade500,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10), // Abbina al raggio della Card
        child: Padding(
          // Padding interno reso responsive
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: Column(
            // MainAxisAlignment.spaceEvenly distribuisce lo spazio verticale
            // in modo uniforme, rendendo il layout flessibile.
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              icon,
              // Il SizedBox fisso è stato rimosso. Lo spazio è gestito da spaceEvenly.
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  // Anche la dimensione del font è resa responsive
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
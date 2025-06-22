import 'package:flutter/material.dart';
import 'package:wellyess/widgets/base_layout.dart';
import 'package:wellyess/widgets/info_row.dart';

class ProfiloAnziano extends StatelessWidget {
  const ProfiloAnziano({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BaseLayout(
      currentIndex: 2,
      onBackPressed: () {
        Navigator.pop(context);
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Profilo',
                style: TextStyle(
                    fontSize: screenWidth * 0.08, // Reso responsivo (era 32)
                    fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(thickness: 1, color: Colors.grey),
            SizedBox(height: screenHeight * 0.025), // Reso responsivo (era 20)

            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: screenWidth * 0.125, // Reso responsivo (era 50)
                    backgroundImage:
                        const AssetImage('assets/images/elder_profile_pic.png'),
                  ),
                  SizedBox(
                      height: screenHeight * 0.012), // Reso responsivo (era 10)
                  Text(
                    'Michele Verdi',
                    style: TextStyle(
                        fontSize: screenWidth * 0.07, // Reso responsivo (era 28)
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.025), // Reso responsivo (era 20)

            const InfoRow(label: 'Data nascita', value: '15 Mag 1948'),
            const Divider(thickness: 1, color: Colors.grey),
            SizedBox(height: screenHeight * 0.018), // Reso responsivo (era 15)

            const InfoRow(label: 'Sesso', value: 'Maschile'),
            const Divider(thickness: 1, color: Colors.grey),
            SizedBox(height: screenHeight * 0.018), // Reso responsivo (era 15)

            const InfoRow(label: 'Allergie', value: 'Polline'),
            const Divider(thickness: 1, color: Colors.grey),
            SizedBox(height: screenHeight * 0.018), // Reso responsivo (era 15)

            const InfoRow(label: 'Intolleranze', value: 'Lattosio'),
            const Divider(thickness: 1, color: Colors.grey),
            SizedBox(height: screenHeight * 0.018), // Reso responsivo (era 15)

            const InfoRow(label: 'Gruppo sanguigno', value: 'A'),
            const Divider(thickness: 1, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
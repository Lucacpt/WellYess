import 'package:flutter/material.dart';
import 'bottom_navbar.dart';
import 'go_back_button.dart'; 

class BaseLayout extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final VoidCallback? onBackPressed;

  const BaseLayout({
    super.key,
    required this.child,
    this.currentIndex = 0,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 90), // margine inferiore per la navbar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // RIGA SUPERIORE con logo e avatar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/logo/wellyess.png',
                        height: 55,
                      ),
                      const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/images/elder_profile_pic.png'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15), // spazio extra tra logo/avatar e contenuto

                  // CONTAINER PRINCIPALE
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Freccia indietro
                          if (onBackPressed != null) ...[
                            BackCircleButton(onPressed: onBackPressed),
                            const SizedBox(height: 20),
                          ],

                          // Contenuto della pagina
                          Expanded(child: child),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // NAVBAR IN FONDO
            Positioned(
              left: 0,
              right: 0,
              bottom: 5,
              child: CustomBottomNavBar(
                currentIndex: currentIndex,
                onTap: (index) {
                  // gestisci navigazione
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

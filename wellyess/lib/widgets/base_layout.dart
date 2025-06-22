import 'package:flutter/material.dart';
import 'package:wellyess/screens/menu_page.dart';
import 'package:wellyess/screens/settings.dart';
import 'bottom_navbar.dart';
import 'go_back_button.dart';
import 'package:wellyess/screens/elder_profile.dart';

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
    // Otteniamo le dimensioni dello schermo per i calcoli
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              // Padding reso responsivo
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.05, // 20
                screenHeight * 0.012, // 10
                screenWidth * 0.05, // 20
                screenHeight * 0.12, // 90, per la navbar
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // RIGA SUPERIORE con logo e avatar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: Semantics(
                          label: 'Logo Wellyess',
                          child: Image.asset(
                            'assets/logo/wellyess.png',
                            // Altezza del logo resa responsiva
                            height: screenHeight * 0.06, // 55
                          ),
                        ),
                      ),
                      Semantics(
                        label: 'Foto profilo utente',
                        button: true,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfiloAnziano(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            // Raggio dell'avatar reso responsivo
                            radius: screenWidth * 0.075, // 30
                            backgroundImage: const AssetImage(
                                'assets/images/elder_profile_pic.png'),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Spazio reso responsivo
                  SizedBox(height: screenHeight * 0.018), // 15

                  // CONTAINER PRINCIPALE
                  Expanded(
                    child: Container(
                      // Padding del container reso responsivo
                      padding: EdgeInsets.all(screenWidth * 0.075), // 30
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // Raggio del bordo reso responsivo
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.075), // 30
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
                            Semantics(
                              button: true,
                              child: BackCircleButton(onPressed: onBackPressed),
                            ),
                            // Spazio reso responsivo
                            SizedBox(height: screenHeight * 0.025), // 20
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
              // Posizione dal basso resa responsiva
              bottom: screenHeight * 0.006, // 5
              child: Semantics(
                container: true,
                label: 'Barra di navigazione principale',
                child: CustomBottomNavBar(
                  currentIndex: currentIndex,
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MenuPage()));
                        break;
                      case 1:
                        Navigator.popUntil(context, (r) => r.isFirst);
                        break;
                      case 2:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SettingsPage()));
                        break;
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
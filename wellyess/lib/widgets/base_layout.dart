import 'package:flutter/material.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/screens/menu_page.dart';
import 'package:wellyess/screens/settings.dart';
import 'bottom_navbar.dart';
import 'go_back_button.dart';
import 'package:wellyess/screens/user_profile.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final VoidCallback? onBackPressed;
  // MODIFICA: Aggiunto userType per rendere il layout dinamico
  final UserType? userType;

  const BaseLayout({
    super.key,
    required this.child,
    this.currentIndex = 0,
    this.onBackPressed,
    this.userType, // MODIFICA: Aggiunto al costruttore
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // MODIFICA: Determina l'immagine e la pagina del profilo in base a userType
    final isCaregiver = userType == UserType.caregiver;
    final profileImageAsset = isCaregiver
        ? 'assets/images/svetlana.jpg'
        : 'assets/images/elder_profile_pic.png';
    final profilePage =
        isCaregiver ? const ProfiloUtente() : const ProfiloUtente();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.05,
                screenHeight * 0.012,
                screenWidth * 0.05,
                screenHeight * 0.12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            height: screenHeight * 0.06,
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
                              MaterialPageRoute(builder: (context) => profilePage),
                            );
                          },
                          child: CircleAvatar(
                            radius: screenWidth * 0.075,
                            backgroundImage: AssetImage(profileImageAsset),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.018),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.075),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.075),
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
                          if (onBackPressed != null) ...[
                            Semantics(
                              button: true,
                              child: BackCircleButton(onPressed: onBackPressed),
                            ),
                            SizedBox(height: screenHeight * 0.025),
                          ],
                          Expanded(child: child),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: screenHeight * 0.006,
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
import 'package:flutter/material.dart';
import 'bottom_navbar.dart';

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
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 90), // margine inferiore per navbar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // RIGA SUPERIORE con back e avatar (più in alto)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (onBackPressed != null)
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: onBackPressed,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      const Spacer(),
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage('assets/images/elder_profile_pic.png'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // spazio verticale più piccolo

                  // Container principale con contenuto variabile
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10)
                          )
                        ]
                      ),
                      child: child,
                    ),
                  ),
                ],
              ),
            ),

            // Navbar in fondo
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

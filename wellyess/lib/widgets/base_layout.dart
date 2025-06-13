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
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // Puoi gestire navigazione qui o passare callback
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Riga superiore: logo e foto profilo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  // qui puoi aggiungere anche il logo se vuoi
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('assets/images/elder_profile_pic.png'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Container principale con contenuto variabile
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

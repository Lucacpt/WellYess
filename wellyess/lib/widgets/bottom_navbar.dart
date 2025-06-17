import 'package:flutter/material.dart';
import 'package:wellyess/screens/menu_page.dart';
import 'package:wellyess/screens/settings.dart';
import 'package:wellyess/screens/homepage.dart';

class CustomBottomNavBar extends StatelessWidget {
  /// Chiamato con 0=Menu, 1=Home, 2=Settings
  final ValueChanged<int>? onTap;
  /// Indice selezionato (per evidenziare l’icona)
  final int currentIndex;

  const CustomBottomNavBar({
    Key? key,
    this.onTap,
    this.currentIndex = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Sfondo navbar
          Positioned(
            bottom: 0,
            left: 20,
            right: 20,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF5DB47F),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu
                  IconButton(
                    iconSize: 30,
                    icon: Icon(
                      Icons.menu,
                      color: currentIndex == 0 ? Colors.white : Colors.white70,
                    ),
                    onPressed: () => onTap?.call(0),
                  ),
                  // Impostazioni
                  IconButton(
                    iconSize: 30,
                    icon: Icon(
                      Icons.settings,
                      color: currentIndex == 2 ? Colors.white : Colors.white70,
                    ),
                    onPressed: () => onTap?.call(2),
                  ),
                ],
              ),
            ),
          ),

          // Home centrale
          Positioned(
            bottom: 5,
            child: GestureDetector(
              onTap: () => onTap?.call(1),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: currentIndex == 1
                      ? const Color(0xFF375647)
                      : Colors.grey.shade600,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.home, size: 36, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

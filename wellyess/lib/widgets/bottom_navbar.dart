import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  /// Chiamato con 0=Menu, 1=Home, 2=Settings
  final ValueChanged<int>? onTap;
  /// Indice selezionato (per evidenziare l’icona)
  final int currentIndex;
  /// Indica se il menu popup è aperto
  final bool isMenuOpen;

  const CustomBottomNavBar({
    super.key,
    this.onTap,
    this.currentIndex = 1,
    this.isMenuOpen = false,
  });

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
                  Container(
                    decoration: isMenuOpen
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          )
                        : null,
                    child: IconButton(
                      iconSize: 30,
                      icon: Icon(
                        Icons.menu,
                        color: isMenuOpen ? Colors.white : Colors.white70,
                      ),
                      onPressed: () => onTap?.call(0),
                    ),
                  ),
                  // Impostazioni
                  Container(
                    decoration: currentIndex == 2
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          )
                        : null,
                    child: IconButton(
                      iconSize: 30,
                      icon: Icon(
                        Icons.settings,
                        color: currentIndex == 2 ? Colors.white : Colors.white70,
                      ),
                      onPressed: () => onTap?.call(2),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Home centrale (sempre verde scuro)
          Positioned(
            bottom: 5,
            child: GestureDetector(
              onTap: () => onTap?.call(1),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF375647),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                  border: currentIndex == 1
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
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
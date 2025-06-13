import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const CustomBottomNavBar({
    super.key,
    this.currentIndex = 1,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90, // spazio totale occupato dalla navbar
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Background della navbar
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
                  IconButton(
                    iconSize: 30,
                    icon: Icon(
                      Icons.menu,
                      color: currentIndex == 0 ? Colors.white : Colors.white70,
                    ),
                    onPressed: () => onTap?.call(0),
                  ),
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

          // Icona Home centrale sporgente
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.home,
                  size: 36,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

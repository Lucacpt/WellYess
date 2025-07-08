import 'package:flutter/material.dart';
import 'package:wellyess/widgets/tappable_reader.dart';
import 'package:wellyess/services/flutter_tts.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class CustomBottomNavBar extends StatelessWidget {
  /// Chiamato con 0=Menu, 1=Home, 2=Settings
  final ValueChanged<int>? onTap;
  /// Indice selezionato (per evidenziare l’icona)
  final int currentIndex;
  /// Indica se il menu popup è aperto
  final bool isMenuOpen;
  /// Accessibilità: alto contrasto
  final bool highContrast;
  /// Accessibilità: fattore dimensione testo
  final double fontSize;

  const CustomBottomNavBar({
    super.key,
    this.onTap,
    this.currentIndex = 1,
    this.isMenuOpen = false,
    this.highContrast = false,
    this.fontSize = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    // Colori per la navbar e le icone, adattati per l'accessibilità
    final Color navBgColor = highContrast ? Colors.black : const Color(0xFF5DB47F);
    final Color iconActiveColor = highContrast ? Colors.yellow.shade700 : Colors.white;
    final Color iconInactiveColor = highContrast ? Colors.yellow.shade200 : Colors.white70;
    final Color homeBgColor = highContrast ? Colors.yellow.shade700 : const Color(0xFF375647);
    final Color homeIconColor = highContrast ? Colors.black : Colors.white;
    final Color borderColor = highContrast ? Colors.black : Colors.white;

    // Limiti massimi per evitare overflow delle icone e dei pulsanti
    final double maxHomeSize = 80;
    final double homeSize = math.min(70 * fontSize, maxHomeSize);
    final double homeIconSize = math.min(36 * fontSize, 40);
    final double iconButtonSize = math.min(30 * fontSize, 36);

    return SizedBox(
      height: 90,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Sfondo arrotondato della navbar
          Positioned(
            bottom: 0,
            left: 20,
            right: 20,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: navBgColor,
                borderRadius: BorderRadius.circular(30),
                border: highContrast ? Border.all(color: Colors.black, width: 2) : null,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Pulsante Menu (sinistra)
                  TappableReader(
                    label: 'Apri menu',
                    child: Container(
                      decoration: isMenuOpen
                          ? BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: borderColor, width: 2),
                            )
                          : null,
                      child: IconButton(
                        iconSize: iconButtonSize,
                        icon: Icon(
                          Icons.menu,
                          color: isMenuOpen ? iconActiveColor : iconInactiveColor,
                        ),
                        onPressed: () {
                          // Annuncia il menu se TalkBack è attivo
                          final access = Provider.of<AccessibilitaModel>(context, listen: false);
                          if (access.talkbackEnabled) {
                            TalkbackService.announce('Apri menu');
                          }
                          onTap?.call(0); // Notifica il tap al parent
                        },
                        tooltip: 'Menu',
                      ),
                    ),
                  ),
                  // Pulsante Impostazioni (destra)
                  TappableReader(
                    label: 'Apri impostazioni',
                    child: Container(
                      // fissa larghezza/altezza in modo che il bordo (anche trasparente)
                      // non alteri il layout al variare dello stato selezionato/hover
                      width: iconButtonSize + 4,
                      height: iconButtonSize + 4,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: currentIndex == 2 ? borderColor : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: IconButton(
                        iconSize: iconButtonSize,
                        padding: EdgeInsets.zero,      // rimuove padding interno variabile
                        constraints: BoxConstraints(), // evita min constraints di default
                        icon: Icon(
                          Icons.settings,
                          color: currentIndex == 2 ? iconActiveColor : iconInactiveColor,
                        ),
                        onPressed: () {
                          final access = Provider.of<AccessibilitaModel>(context, listen: false);
                          if (access.talkbackEnabled) {
                            TalkbackService.announce('Apri impostazioni');
                          }
                          onTap?.call(2);
                        },
                        tooltip: 'Impostazioni',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Pulsante Home centrale (in rilievo)
          Positioned(
            bottom: 5,
            child: TappableReader(
              label: 'Home',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // Annuncia "Home" se TalkBack è attivo
                  final access = Provider.of<AccessibilitaModel>(context, listen: false);
                  if (access.talkbackEnabled) {
                    TalkbackService.announce('Home');
                  }
                  onTap?.call(1); // Notifica il tap al parent
                },
                child: Container(
                  width: homeSize,
                  height: homeSize,
                  decoration: BoxDecoration(
                    color: homeBgColor,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                    border: currentIndex == 1
                        ? Border.all(color: borderColor, width: 3)
                        : null,
                  ),
                  child: Icon(
                    Icons.home,
                    size: homeIconSize,
                    color: homeIconColor,
                    semanticLabel: 'Home',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
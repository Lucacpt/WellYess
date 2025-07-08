import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/screens/med_diary.dart';
import 'package:wellyess/screens/sos.dart';
import 'package:wellyess/screens/monitoring_section.dart';
import 'package:wellyess/screens/login_page.dart';
import 'package:wellyess/screens/consigli_salute.dart';
import 'package:wellyess/screens/med_section.dart';
import 'package:wellyess/screens/tutorial_page.dart'; // ← import Guida rapida
import 'package:wellyess/models/accessibilita_model.dart';

// Popup menu principale dell'app, mostra le voci di navigazione in base al tipo utente
class MenuPopup extends StatelessWidget {
  final UserType userType; // Tipo utente (caregiver o anziano)

  const MenuPopup({
    super.key,
    required this.userType,
  });

  // Gestisce il tap su una voce di menu e naviga alla pagina corrispondente
  void _handleMenuTap(BuildContext context, String key) {
    Navigator.of(context).pop(); // Chiudi il popup
    switch (key) {
      case 'farmaci':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const FarmaciPage()));
        break;
      case 'agenda':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MedDiaryPage()));
        break;
      case 'sos':
      case 'sos_elder':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergenzaScreen()));
        break;
      case 'parametri':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MonitoraggioParametriPage()));
        break;
      case 'logout':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
        break;
      case 'sport':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ConsigliSalutePage()));
        break;
      case 'tutorial': // ← voce Guida rapida
        Navigator.push(context, MaterialPageRoute(builder: (_) => const TutorialPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Recupera impostazioni di accessibilità dal provider
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    // Determina se l'utente è un caregiver
    final isCaregiver = userType == UserType.caregiver;

    // Definisce le voci di menu in base al tipo utente
    final menuItems = isCaregiver
        ? [
            _MenuItemData('Farmaci', Icons.medication_outlined, 'farmaci'),
            _MenuItemData('Agenda', Icons.calendar_month, 'agenda'),
            _MenuItemData('Gestione SOS', Icons.warning_amber_rounded, 'sos'),
            _MenuItemData('Parametri', Icons.monitor_heart, 'parametri'),
            _MenuItemData('Guida rapida', Icons.help_outline, 'tutorial'), // ← aggiunta
            _MenuItemData('Logout', Icons.logout, 'logout'),
          ]
        : [
            _MenuItemData('Farmaci', Icons.medication_outlined, 'farmaci'),
            _MenuItemData('Agenda Medica', Icons.calendar_month, 'agenda'),
            _MenuItemData('Sport & Alimentazione', Icons.restaurant, 'sport'),
            _MenuItemData('Parametri', Icons.monitor_heart, 'parametri'),
            _MenuItemData('Guida rapida', Icons.help_outline, 'tutorial'), // ← aggiunta
            _MenuItemData('Logout', Icons.logout, 'logout'),
            _MenuItemData('SOS', Icons.sos, 'sos_elder', isSos: true),
          ];

    // Colori accessibili per sfondo, testo e icone
    final Color bgColor = highContrast ? Colors.yellow.shade100 : Colors.white;
    final Color borderColor = highContrast ? Colors.black : Colors.transparent;
    final Color defaultTextColor = highContrast ? Colors.black : Colors.black87;
    final Color defaultIconColor = highContrast ? Colors.black : const Color(0xFF5DB47F);
    final Color sosBgColor = highContrast ? Colors.black : const Color(0xFFFF1744);
    final Color sosTextColor = highContrast ? Colors.yellow.shade700 : Colors.white;
    final Color sosIconColor = highContrast ? Colors.yellow.shade700 : Colors.white;
    final Color logoutTextColor = highContrast ? Colors.black : Colors.red;
    final Color logoutIconColor = highContrast ? Colors.red.shade800 : Colors.red.shade300;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 320,
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 18),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: borderColor, width: highContrast ? 2 : 0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 32,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Genera ogni voce di menu con stile e comportamento diversi se SOS o Logout
              ...menuItems.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _handleMenuTap(context, item.key), // Gestisce il tap sulla voce
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: item.isSos == true
                              ? sosBgColor
                              : item.key == 'logout'
                                ? (highContrast ? Colors.yellow.shade200 : Colors.grey.shade200) // Più chiaro in contrasto
                                : (highContrast ? Colors.yellow.shade600 : const Color(0xFF5DB47F).withOpacity(0.08)),
                          border: item.isSos == true
                              ? Border.all(color: sosBgColor, width: 2.5)
                              : null,
                        ),
                        child: Row(
                          children: [
                            // Icona della voce di menu
                            Icon(
                              item.icon,
                              color: item.isSos == true
                                  ? sosIconColor
                                  : item.key == 'logout'
                                      ? logoutIconColor
                                      : defaultIconColor,
                              size: item.isSos == true ? 34 : 28,
                            ),
                            const SizedBox(width: 18),
                            // Testo della voce di menu
                            Expanded(
                              child: Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: ((item.isSos == true ? 22 : 19) * fontSizeFactor).clamp(16.0, 26.0),
                                  fontWeight: item.isSos == true ? FontWeight.bold : FontWeight.w600,
                                  color: item.isSos == true
                                      ? sosTextColor
                                      : item.key == 'logout'
                                          ? logoutTextColor
                                          : defaultTextColor,
                                  letterSpacing: item.isSos == true ? 1.2 : 0,
                                ),
                              ),
                            ),
                            // Freccia a destra solo se non è SOS
                            if (!item.isSos)
                              Icon(Icons.chevron_right, color: highContrast ? Colors.black : Colors.grey, size: 22),
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// Classe di supporto per rappresentare una voce di menu
class _MenuItemData {
  final String label;      // Testo della voce
  final IconData icon;     // Icona della voce
  final String key;        // Chiave per identificare la voce
  final bool isSos;        // True se la voce è SOS (stile speciale)
  _MenuItemData(this.label, this.icon, this.key, {this.isSos = false});
}
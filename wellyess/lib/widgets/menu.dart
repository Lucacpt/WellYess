import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/screens/med_diary.dart';
import 'package:wellyess/screens/sos.dart';
import 'package:wellyess/screens/monitoring_section.dart';
import 'package:wellyess/screens/login_page.dart';
import 'package:wellyess/screens/consigli_salute.dart';
import 'package:wellyess/screens/med_section.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class MenuPopup extends StatelessWidget {
  final UserType userType;

  const MenuPopup({
    super.key,
    required this.userType,
  });

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
    }
  }

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    final isCaregiver = userType == UserType.caregiver;
    final menuItems = isCaregiver
        ? [
            _MenuItemData('Farmaci', Icons.medication_outlined, 'farmaci'),
            _MenuItemData('Agenda', Icons.calendar_month, 'agenda'),
            _MenuItemData('Gestione SOS', Icons.warning_amber_rounded, 'sos'),
            _MenuItemData('Parametri', Icons.monitor_heart, 'parametri'),
            _MenuItemData('Logout', Icons.logout, 'logout'),
          ]
        : [
            _MenuItemData('Farmaci', Icons.medication_outlined, 'farmaci'),
            _MenuItemData('Agenda Medica', Icons.calendar_month, 'agenda'),
            _MenuItemData('Sport & Alimentazione', Icons.restaurant, 'sport'),
            _MenuItemData('Parametri', Icons.monitor_heart, 'parametri'),
            _MenuItemData('Logout', Icons.logout, 'logout'),
            _MenuItemData('SOS', Icons.sos, 'sos_elder', isSos: true),
          ];

    // Colori accessibili
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
              ...menuItems.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _handleMenuTap(context, item.key),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: item.isSos == true
                              ? sosBgColor
                              : item.key == 'logout'
                                ? (highContrast ? Colors.yellow.shade200 : Colors.grey.shade200) // <-- più chiaro in contrasto
                                : (highContrast ? Colors.yellow.shade600 : const Color(0xFF5DB47F).withOpacity(0.08)),
                          border: item.isSos == true
                              ? Border.all(color: sosBgColor, width: 2.5)
                              : null,
                        ),
                        child: Row(
                          children: [
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

class _MenuItemData {
  final String label;
  final IconData icon;
  final String key;
  final bool isSos;
  _MenuItemData(this.label, this.icon, this.key, {this.isSos = false});
}
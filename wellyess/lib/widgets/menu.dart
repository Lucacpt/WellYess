import 'package:flutter/material.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/screens/med_diary.dart';
import 'package:wellyess/screens/sos.dart';
import 'package:wellyess/screens/monitoring_section.dart';
import 'package:wellyess/screens/login_page.dart';
import 'package:wellyess/screens/consigli_salute.dart';
import 'package:wellyess/screens/med_section.dart';

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

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 320,
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
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
                              ? const Color(0xFFFF1744) // tutto rosso acceso per SOS
                              : item.key == 'logout'
                                  ? Colors.grey.shade200 // grigio chiaro per logout
                                  : const Color(0xFF5DB47F).withOpacity(0.08),
                          border: item.isSos == true
                              ? Border.all(color: const Color(0xFFFF1744), width: 2.5)
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              color: item.isSos == true
                                  ? Colors.white // icona bianca per SOS
                                  : item.key == 'logout'
                                      ? Colors.red.shade300
                                      : const Color(0xFF5DB47F),
                              size: item.isSos == true ? 34 : 28, // SOS più grande
                            ),
                            const SizedBox(width: 18),
                            Expanded(
                              child: Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: item.isSos == true ? 22 : 19, // SOS più grande
                                  fontWeight: item.isSos == true ? FontWeight.bold : FontWeight.w600,
                                  color: item.isSos == true
                                      ? Colors.white // testo bianco per SOS
                                      : item.key == 'logout'
                                          ? Colors.red // testo rosso per logout
                                          : Colors.black87,
                                  letterSpacing: item.isSos == true ? 1.2 : 0,
                                ),
                              ),
                            ),
                            if (!item.isSos)
                              const Icon(Icons.chevron_right, color: Colors.grey, size: 22),
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
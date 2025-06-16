import 'package:flutter/material.dart';
import '../widgets/base_layout.dart';
import 'package:wellyess/screens/elder_profile.dart';
import 'package:flutter_svg/flutter_svg.dart'; 
import 'package:wellyess/screens/profilo_caregiver.dart'; 

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      currentIndex: 2, // Indice per la pagina delle impostazioni nella navbar
      onBackPressed: () => Navigator.of(context).pop(),
      child: Align( 
        alignment: Alignment.topCenter, 
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 0.0, right: 16.0, bottom: 16.0), 
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                const Text(
                  'Impostazioni',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                const Divider(),
                const SizedBox(height: 10),

                const SizedBox(height: 30),

                _SettingsRow(
                  iconWidget: SvgPicture.asset( 
                    'assets/icons/Account_Icon.svg', // Assicurati che questo file esista
                    width: 32,
                    height: 32,
                  ),
                  label: 'Account',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfiloAnziano()), 
                    );
                  },
                ),
                const Divider(),
                const SizedBox(height: 20),

                _SettingsRow(
                  iconWidget: SvgPicture.asset( 
                    'assets/icons/Alert Icon.svg', // Assicurati che questo file esista
                    width: 32,
                    height: 32,
                  ),
                  label: 'Notifiche',
                  onTap: () {
                  },
                ),
                const Divider(),
                const SizedBox(height: 20),

                _SettingsRow(
                  iconWidget: SvgPicture.asset( 
                    'assets/icons/Accessibiliy Icon.svg', // Assicurati che questo file esista
                    width: 32,
                    height: 32,
                  ),
                  label: 'Accessibilità',
                  onTap: () {
                  },
                ),
                const Divider(),
                const SizedBox(height: 20),

                _SettingsRow(
                  iconWidget: SvgPicture.asset( 
                    'assets/icons/Caregiver Icon.svg', // Assicurati che questo file esista
                    width: 32,
                    height: 32,
                  ),
                  label: 'Caregiver',
                  onTap: () { // Azione di navigazione per Caregiver
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CaregiverProfilePage()), 
                    );
                  },
                ),
                const Divider(),
                const SizedBox(height: 20),

                _SettingsRow(
                  iconWidget: SvgPicture.asset( 
                    'assets/icons/Help Me Icon.svg', // Assicurati che questo file esista
                    width: 32,
                    height: 32,
                  ),
                  label: 'Help Me',
                  onTap: () {
                  },
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget helper per una riga di impostazione
class _SettingsRow extends StatelessWidget {
  final IconData? iconData; 
  final Widget? iconWidget; 
  final String label;
  final VoidCallback onTap;

  const _SettingsRow({
    this.iconData,
    this.iconWidget,
    required this.label,
    required this.onTap,
  }) : assert(iconData != null || iconWidget != null, 'È necessario fornire iconData o iconWidget');

  @override
  Widget build(BuildContext context) {
    Widget currentIcon;
    if (iconWidget != null) {
      currentIcon = iconWidget!;
    } else {
      currentIcon = Icon( 
        iconData!,
        size: 32,
        color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black87,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0), 
          child: Row(
            children: [
              Padding( 
                padding: const EdgeInsets.only(left: 16.0), 
                child: currentIcon, 
              ),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center, 
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold, 
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
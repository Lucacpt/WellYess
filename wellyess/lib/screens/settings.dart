import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/screens/login_page.dart';
import 'package:wellyess/screens/profilo_caregiver.dart';
import 'package:wellyess/screens/user_profile.dart';
import '../widgets/base_layout.dart';

// MODIFICA: Convertito in StatefulWidget
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserType? _userType;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    final prefs = await SharedPreferences.getInstance();
    final userTypeString = prefs.getString('userType');
    if (mounted) {
      setState(() {
        if (userTypeString != null) {
          _userType =
              UserType.values.firstWhere((e) => e.toString() == userTypeString);
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double iconSize = screenWidth * 0.08;
    final isCaregiver = _userType == UserType.caregiver;

    return BaseLayout(
      userType: _userType,
      currentIndex: 2,
      onBackPressed: () => Navigator.of(context).pop(),
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Impostazioni',
                  style: TextStyle(
                    fontSize: screenWidth * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                const Divider(),
                SizedBox(height: screenHeight * 0.01),
                SizedBox(height: screenHeight * 0.03),
                _SettingsRow(
                  iconWidget: SvgPicture.asset(
                    'assets/icons/Account_Icon.svg',
                    width: iconSize,
                    height: iconSize,
                  ),
                  label: 'Profilo',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfiloUtente()),
                    );
                  },
                ),
                const Divider(),
                SizedBox(height: screenHeight * 0.025),
                _SettingsRow(
                  iconWidget: SvgPicture.asset(
                    'assets/icons/Alert Icon.svg',
                    width: iconSize,
                    height: iconSize,
                  ),
                  label: 'Notifiche',
                  onTap: () {},
                ),
                const Divider(),
                SizedBox(height: screenHeight * 0.025),
                _SettingsRow(
                  iconWidget: SvgPicture.asset(
                    'assets/icons/Accessibiliy Icon.svg',
                    width: iconSize,
                    height: iconSize,
                  ),
                  label: 'Accessibilità',
                  onTap: () {},
                ),
                const Divider(),
                SizedBox(height: screenHeight * 0.025),
                // MODIFICA: Riga dinamica per Assistente/Assistito
                _SettingsRow(
                  iconWidget: SvgPicture.asset(
                    'assets/icons/Caregiver Icon.svg',
                    width: iconSize,
                    height: iconSize,
                  ),
                  label: isCaregiver ? 'Assistito' : 'Assistente',
                  onTap: () {
                    if (isCaregiver) {
                      // Il caregiver visualizza il profilo dell'anziano
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ProfiloUtente(forceElderView: true)),
                      );
                    } else {
                      // L'anziano visualizza il profilo del caregiver
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CaregiverProfilePage()),
                      );
                    }
                  },
                ),
                const Divider(),
                SizedBox(height: screenHeight * 0.025),
                _SettingsRow(
                  iconWidget: SvgPicture.asset(
                    'assets/icons/Logout.svg',
                    width: iconSize,
                    height: iconSize,
                  ),
                  label: 'Esci dal profilo',
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('userType'); // <-- rimuove le credenziali
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (r) => false,
                    );
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
  }) : assert(iconData != null || iconWidget != null,
            'È necessario fornire iconData o iconWidget');

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    Widget currentIcon;

    if (iconWidget != null) {
      currentIcon = iconWidget!;
    } else {
      currentIcon = Icon(
        iconData!,
        size: screenWidth * 0.08, // Reso responsivo
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white70
            : Colors.black87,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.025, horizontal: 0.0), // Reso responsivo
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.04), // Reso responsivo
                child: currentIcon,
              ),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.045, // Reso responsivo
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.04), // Reso responsivo
                child: Icon(Icons.arrow_forward_ios,
                    size: screenWidth * 0.04, color: Colors.grey.shade600), // Reso responsivo
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:wellyess/screens/login_page.dart';
import 'package:wellyess/screens/profilo_caregiver.dart';
import 'package:wellyess/screens/user_profile.dart';
import '../widgets/base_layout.dart';
import 'accessibilita_section.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

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

  String _getIconAsset(String baseName, bool highContrast) {
    switch (baseName) {
      case 'account':
        return highContrast
            ? 'assets/icons/Account_Icon_black.svg'
            : 'assets/icons/Account_Icon.svg';
      case 'help':
        return highContrast
            ? 'assets/icons/Help_black.svg'
            : 'assets/icons/Help.svg';
      case 'accessibility':
        return highContrast
            ? 'assets/icons/Accessibility_black.svg'
            : 'assets/icons/Accessibiliy Icon.svg';
      case 'caregiver':
        return highContrast
            ? 'assets/icons/Caregiver_Icon_black.svg'
            : 'assets/icons/Caregiver Icon.svg';
      case 'logout':
        return highContrast
            ? 'assets/icons/Logout_black.svg'
            : 'assets/icons/Logout.svg';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double iconSize = screenWidth * 0.08 * fontSizeFactor;
    final isCaregiver = _userType == UserType.caregiver;

    return BaseLayout(
      userType: _userType,
      currentIndex: 2,
      onBackPressed: () => Navigator.of(context).pop(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              'Impostazioni',
              style: TextStyle(
                fontSize: screenWidth * 0.08 * fontSizeFactor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          // Solo il contenuto sottostante scorre
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: screenHeight * 0.01),
                    _SettingsRow(
                      iconWidget: SvgPicture.asset(
                        _getIconAsset('account', highContrast),
                        width: iconSize,
                        height: iconSize,
                      ),
                      label: 'Profilo',
                      fontSizeFactor: fontSizeFactor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfiloUtente()),
                        );
                      },
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    _SettingsRow(
                      iconWidget: SvgPicture.asset(
                        _getIconAsset('help', highContrast),
                        width: iconSize,
                        height: iconSize,
                      ),
                      label: 'Guida rapida',
                      fontSizeFactor: fontSizeFactor,
                      onTap: () {
                          // Collegare alla pagina guida_rapida_section.dart
                      },
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    _SettingsRow(
                      iconWidget: SvgPicture.asset(
                        _getIconAsset('accessibility', highContrast),
                        width: iconSize,
                        height: iconSize,
                      ),
                      label: 'Accessibilità',
                      fontSizeFactor: fontSizeFactor,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccessibilitaSection(),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    _SettingsRow(
                      iconWidget: SvgPicture.asset(
                        _getIconAsset('caregiver', highContrast),
                        width: iconSize,
                        height: iconSize,
                      ),
                      label: isCaregiver ? 'Assistito' : 'Assistente',
                      fontSizeFactor: fontSizeFactor,
                      onTap: () {
                        if (isCaregiver) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ProfiloUtente(forceElderView: true)),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CaregiverProfilePage()),
                          );
                        }
                      },
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    _SettingsRow(
                      iconWidget: SvgPicture.asset(
                        _getIconAsset('logout', highContrast),
                        width: iconSize,
                        height: iconSize,
                      ),
                      label: 'Esci dal profilo',
                      fontSizeFactor: fontSizeFactor,
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('userType');
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          (r) => false,
                        );
                      },
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget helper per una riga di impostazione
class _SettingsRow extends StatelessWidget {
  final IconData? iconData;
  final Widget? iconWidget;
  final String label;
  final double fontSizeFactor;
  final VoidCallback onTap;

  const _SettingsRow({
    this.iconData,
    this.iconWidget,
    required this.label,
    required this.fontSizeFactor,
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
        size: screenWidth * 0.08 * fontSizeFactor,
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
              vertical: screenWidth * 0.025, horizontal: 0.0),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.04),
                child: currentIcon,
              ),
              Expanded(
                child: Text(
                  label,
                  textAlign: TextAlign.center, // sempre centrato
                  style: TextStyle(
                    fontSize: screenWidth * 0.045 * fontSizeFactor, // cresce con fontSizeFactor
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.04),
                child: Icon(Icons.arrow_forward_ios,
                    size: screenWidth * 0.04 * fontSizeFactor, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
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
import 'package:wellyess/widgets/tappable_reader.dart';
import 'tutorial_page.dart';

// Pagina delle impostazioni dell'applicazione
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserType? _userType; // Tipo utente (caregiver, anziano, ecc.)
  bool _isLoading = true; // Stato di caricamento

  @override
  void initState() {
    super.initState();
    _loadUserType(); // Carica il tipo di utente dalle preferenze
  }

  // Carica il tipo di utente dalle SharedPreferences
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

  // Restituisce il percorso dell'icona SVG in base al tema (contrasto alto o normale)
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
    // Mostra loader se i dati sono in caricamento
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Recupera impostazioni di accessibilità dal provider
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double iconSize = screenWidth * 0.08 * fontSizeFactor;
    final isCaregiver = _userType == UserType.caregiver;

    return BaseLayout(
      pageTitle: 'Impostazioni', // Titolo della pagina nella barra superiore
      userType: _userType,
      currentIndex: 2,
      onBackPressed: () => Navigator.of(context).pop(), // Azione per il tasto indietro
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Titolo della pagina
          TappableReader(
            label: 'Titolo pagina Impostazioni',
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Impostazioni',
                style: TextStyle(
                  fontSize: screenWidth * 0.08 * fontSizeFactor,
                  fontWeight: FontWeight.bold,
                ),
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
                    // Voce per accedere al profilo utente
                    TappableReader(
                      label: 'Voce Impostazioni Profilo',
                      child: _SettingsRow(
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
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    // Voce per accedere alla guida rapida
                    TappableReader(
                      label: 'Voce Impostazioni Guida rapida',
                      child: _SettingsRow(
                        iconData: Icons.help_outline,
                        label: 'Guida rapida',
                        fontSizeFactor: fontSizeFactor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TutorialPage()),
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    // Voce per accedere alle impostazioni di accessibilità
                    TappableReader(
                      label: 'Voce Impostazioni Accessibilità',
                      child: _SettingsRow(
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
                    ),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    // Voce per accedere al profilo assistito/caregiver
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
                          // Se utente è caregiver, mostra profilo dell'assistito
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ProfiloUtente(forceElderView: true)),
                          );
                        } else {
                          // Se utente è anziano, mostra profilo caregiver
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
                    // Voce per effettuare il logout
                    _SettingsRow(
                      iconWidget: SvgPicture.asset(
                        _getIconAsset('logout', highContrast),
                        width: iconSize,
                        height: iconSize,
                      ),
                      label: 'Esci dal profilo',
                      fontSizeFactor: fontSizeFactor,
                      onTap: () async {
                        // Rimuove il tipo utente dalle preferenze e torna alla pagina di login
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
  final IconData? iconData; // Icona standard (opzionale)
  final Widget? iconWidget; // Widget icona custom (opzionale)
  final String label; // Testo della voce di impostazione
  final double fontSizeFactor; // Fattore di scala per il testo
  final VoidCallback onTap; // Azione al tap

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

    // Scegli l'icona da mostrare (SVG o standard)
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
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/models/user_model.dart';
import '../widgets/base_layout.dart';
import '../widgets/feature_card.dart';
import '../widgets/sos_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'med_section.dart';
import 'consigli_salute.dart';
import 'sos.dart';
import 'monitoring_section.dart';
import 'med_diary.dart';
import 'user_profile.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class HomePage extends StatefulWidget {
  final int? farmacoKeyToShow;

  const HomePage({super.key, this.farmacoKeyToShow});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserType? _userType;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserType();

    // Se c'è una chiave da evidenziare, apri subito la FarmaciPage
    if (widget.farmacoKeyToShow != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>
                  FarmaciPage(farmacoKeyToShow: widget.farmacoKeyToShow!),
            ),
          );
        }
      });
    }
  }

  Future<void> _loadUserType() async {
    final prefs = await SharedPreferences.getInstance();
    final userTypeString = prefs.getString('userType');
    if (mounted) {
      setState(() {
        _userType = userTypeString != null
            ? UserType.values
                .firstWhere((e) => e.toString() == userTypeString)
            : null;
        _isLoading = false;
      });
    }
  }

  String _getIconAsset(String baseName, bool highContrast) {
    // Usa la versione nera se highContrast, altrimenti la versione verde
    switch (baseName) {
      case 'pills':
        return highContrast
            ? 'assets/icons/Pill_icon_black_v.svg'
            : 'assets/icons/pills.svg';
      case 'heartbeat':
        return highContrast
            ? 'assets/icons/Heartbeat_black_v.svg'
            : 'assets/icons/heartbeat.svg';
      case 'calendar':
        return highContrast
            ? 'assets/icons/Caldendar_black_v.svg'
            : 'assets/icons/calendar.svg';
      case 'sport':
        return highContrast
            ? 'assets/icons/Sport_black_v.svg'
            : 'assets/icons/sport_food.svg';
      case 'elder':
        return highContrast
            ? 'assets/icons/Elder_black_v.svg'
            : 'assets/icons/elder_ic.svg';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final access = context.watch<AccessibilitaModel>();
    final highContrast = access.highContrast;
    final fontSizeFactor = access.fontSizeFactor;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double iconSize = screenWidth * 0.14 * fontSizeFactor;
    final double cardHeight = screenHeight * 0.16;

    if (_isLoading) {
      return BaseLayout(
        userType: _userType,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final isCaregiver = _userType == UserType.caregiver;

    return BaseLayout(
      currentIndex: 1,
      userType: _userType,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.01),
            Align(
              alignment: Alignment.center,
              child: Text(
                isCaregiver ? "Bentornata,\nSvetlana!" : "Bentornato,\nMichele!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.092 * fontSizeFactor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            SizedBox(height: screenHeight * 0.02),
            Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: cardHeight,
                          child: FeatureCard(
                            icon: SvgPicture.asset(
                              _getIconAsset('pills', highContrast),
                              height: iconSize,
                              width: iconSize,
                            ),
                            label: "Farmaci",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const FarmaciPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: SizedBox(
                          height: cardHeight,
                          child: FeatureCard(
                            icon: SvgPicture.asset(
                              _getIconAsset('heartbeat', highContrast),
                              height: iconSize,
                              width: iconSize,
                            ),
                            label: "Parametri",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MonitoraggioParametriPage()),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenWidth * 0.04),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: cardHeight,
                          child: FeatureCard(
                            icon: SvgPicture.asset(
                              _getIconAsset('calendar', highContrast),
                              height: iconSize,
                              width: iconSize,
                            ),
                            label: "Agenda",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MedDiaryPage(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: SizedBox(
                          height: cardHeight,
                          child: isCaregiver
                              ? _buildAssistitoCard(iconSize, highContrast, fontSizeFactor)
                              : _buildConsigliCard(iconSize, highContrast, fontSizeFactor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.1,
              child: SosButton(
                userType: _userType!,
                hasNewRequest: isCaregiver,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EmergenzaScreen()),
                  );
                },
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
          ],
        ),
      ),
    );
  }

  Widget _buildAssistitoCard(double iconSize, bool highContrast, double fontSizeFactor) {
    return FeatureCard(
      icon: SvgPicture.asset(
        _getIconAsset('elder', highContrast),
        height: iconSize,
        width: iconSize,
      ),
      label: "Assistito",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfiloUtente(forceElderView: true),
          ),
        );
      },
    );
  }

  Widget _buildConsigliCard(double iconSize, bool highContrast, double fontSizeFactor) {
    return FeatureCard(
      icon: SvgPicture.asset(
        _getIconAsset('sport', highContrast),
        height: iconSize,
        width: iconSize,
      ),
      label: "Salute",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ConsigliSalutePage(),
          ),
        );
      },
    );
  }
}
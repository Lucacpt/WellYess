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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double iconSize = screenWidth * 0.14;
    final double cardHeight = screenHeight * 0.14;

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
            Text(
              isCaregiver ? "Bentornata,\nFederica!" : "Bentornato,\nMichele!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: screenWidth * 0.1,
                fontWeight: FontWeight.bold,
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
                              'assets/icons/pills.svg',
                              height: iconSize,
                              width: iconSize,
                              colorFilter: const ColorFilter.mode(
                                  Color(0xFF5DB47F), BlendMode.srcIn),
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
                              'assets/icons/heartbeat.svg',
                              height: iconSize,
                              width: iconSize,
                              colorFilter: const ColorFilter.mode(
                                  Color(0xFF5DB47F), BlendMode.srcIn),
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
                              'assets/icons/calendar.svg',
                              height: iconSize,
                              width: iconSize,
                              colorFilter: const ColorFilter.mode(
                                  Color(0xFF5DB47F), BlendMode.srcIn),
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
                              ? _buildAssistitoCard(iconSize)
                              : _buildConsigliCard(iconSize),
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

  Widget _buildAssistitoCard(double iconSize) {
    return FeatureCard(
      icon: SvgPicture.asset(
        'assets/icons/elder_ic.svg',
        height: iconSize,
        width: iconSize,
        colorFilter:
            const ColorFilter.mode(Color(0xFF5DB47F), BlendMode.srcIn),
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

  Widget _buildConsigliCard(double iconSize) {
    return FeatureCard(
      icon: SvgPicture.asset(
        'assets/icons/sport_food.svg',
        height: iconSize,
        width: iconSize,
        colorFilter:
            const ColorFilter.mode(Color(0xFF5DB47F), BlendMode.srcIn),
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
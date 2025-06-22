import 'package:flutter/material.dart';
import '../widgets/base_layout.dart';
import '../widgets/feature_card.dart';
import '../widgets/sos_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'med_section.dart';
import 'consigli_salute.dart';
import 'sos.dart';
import 'monitoring_section.dart';
import 'med_diary.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double iconSize = screenWidth * 0.14;

    return BaseLayout(
      currentIndex: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.01),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF5DB47F),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                "Bentornato,\nMichele!",
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
              SizedBox(height: screenHeight * 0.015),

              // NUOVA STRUTTURA ROBUSTA CON COLUMN E ROW
              Column(
                children: [
                  // Prima riga di card
                  Row(
                    children: [
                      Expanded(
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
                      SizedBox(width: screenWidth * 0.04), // Spazio orizzontale
                      Expanded(
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
                    ],
                  ),
                  SizedBox(height: screenWidth * 0.04), // Spazio verticale
                  // Seconda riga di card
                  Row(
                    children: [
                      Expanded(
                        child: FeatureCard(
                          icon: SvgPicture.asset(
                            'assets/icons/calendar.svg',
                            height: iconSize,
                            width: iconSize,
                            colorFilter: const ColorFilter.mode(
                                Color(0xFF5DB47F), BlendMode.srcIn),
                          ),
                          label: "Agenda Medica",
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
                      SizedBox(width: screenWidth * 0.04), // Spazio orizzontale
                      Expanded(
                        child: FeatureCard(
                          icon: SvgPicture.asset(
                            'assets/icons/sport_food.svg',
                            height: iconSize,
                            width: iconSize,
                            colorFilter: const ColorFilter.mode(
                                Color(0xFF5DB47F), BlendMode.srcIn),
                          ),
                          label: "Consigli Di\nSalute",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ConsigliSalutePage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.02),
              SizedBox(
                width: double.infinity,
                height: screenHeight * 0.1,
                child: SosButton(
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
      ),
    );
  }
}
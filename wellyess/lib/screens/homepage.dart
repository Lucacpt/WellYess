import 'package:flutter/material.dart';
import '../widgets/base_layout.dart';
import '../widgets/feature_card.dart';
import '../widgets/sos_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'med_section.dart';
import 'consigli_salute.dart';
import 'sos.dart'; // <-- IMPORTA LA SCHERMATA DI EMERGENZA

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      currentIndex: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Bentornato,\nMichele!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                childAspectRatio: 1,
                children: [
                  FeatureCard(
                    icon: SvgPicture.asset(
                      'assets/icons/pills.svg',
                      height: 60,
                      width: 60,
                      colorFilter: ColorFilter.mode(const Color(0xFF5DB47F), BlendMode.srcIn),
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
                  FeatureCard(
                    icon: SvgPicture.asset(
                      'assets/icons/heartbeat.svg',
                      height: 60,
                      width: 60,
                      colorFilter: ColorFilter.mode(const Color(0xFF5DB47F), BlendMode.srcIn),
                    ),
                    label: "Parametri",
                    onTap: () {},
                  ),
                  FeatureCard(
                    icon: SvgPicture.asset(
                      'assets/icons/calendar.svg',
                      height: 50,
                      width: 50,
                      colorFilter: ColorFilter.mode(const Color(0xFF5DB47F), BlendMode.srcIn),
                    ),
                    label: "Agenda Medica",
                    onTap: () {},
                  ),
                  FeatureCard(
                    icon: SvgPicture.asset(
                      'assets/icons/sport_food.svg',
                      height: 50,
                      width: 50,
                      colorFilter: ColorFilter.mode(const Color(0xFF5DB47F), BlendMode.srcIn),
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
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 90,
              child: SosButton(
                onPressed: () { // <-- MODIFICA QUI
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EmergenzaScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
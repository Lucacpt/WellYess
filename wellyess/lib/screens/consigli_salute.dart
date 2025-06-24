import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/base_layout.dart';

class ConsigliSalutePage extends StatefulWidget {
  const ConsigliSalutePage({super.key});

  @override
  State<ConsigliSalutePage> createState() => _ConsigliSalutePageState();
}

class _ConsigliSalutePageState extends State<ConsigliSalutePage> {
  int _currentTabIndex = 0;
  Offset _slideBeginOffset = const Offset(1.0, 0.0);

  final List<Map<String, String>> _attivitaFisicaTips = const [
    {
      "svgAssetPath": "assets/icons/Vector.svg",
      "title": "Camminata leggera",
      "subtitle": "Almeno 30 minuti al giorno",
    },
    {
      "svgAssetPath": "assets/icons/dolce.svg",
      "title": "Stretching dolce",
      "subtitle": "Esercizi di mobilità",
    },
    {
      "svgAssetPath": "assets/icons/compass.svg",
      "title": "Orari consigliati",
      "subtitle": "Evitare le ore calde",
    },
    {
      "svgAssetPath": "assets/icons/divano.svg",
      "title": "Esercizi da seduti",
      "subtitle": "Attiva la circolazione",
    },
  ];

  final List<Map<String, String>> _alimentazioneTips = const [
    {
      "svgAssetPath": "assets/icons/mela.svg",
      "title": "Frutta e verdura",
      "subtitle": "Cinque porzioni al giorno",
    },
    {
      "svgAssetPath": "assets/icons/fish.svg",
      "title": "Proteine magre",
      "subtitle": "Pesce, legumi, carni bianche",
    },
    {
      "svgAssetPath": "assets/icons/no_sugar.svg",
      "title": "Limitare lo zucchero",
      "subtitle": "Evitare bevande zuccherate",
    },
    {
      "svgAssetPath": "assets/icons/bottle.svg",
      "title": "Bere regolarmente",
      "subtitle": "Mantieni il corpo idratato",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      onBackPressed: () => Navigator.of(context).pop(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Consigli Di Salute',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (_currentTabIndex == 1) {
                          setState(() {
                            _slideBeginOffset = const Offset(-1.0, 0.0);
                            _currentTabIndex = 0;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: _currentTabIndex == 0
                            ? BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.green.shade700,
                                    width: 3,
                                  ),
                                ),
                              )
                            : null,
                        child: Center(
                          child: Text(
                            'Attività Fisica',
                            style: TextStyle(
                              fontSize: 15,
                              color: _currentTabIndex == 0
                                  ? Colors.green.shade700
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (_currentTabIndex == 0) {
                          setState(() {
                            _slideBeginOffset = const Offset(1.0, 0.0);
                            _currentTabIndex = 1;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: _currentTabIndex == 1
                            ? BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.green.shade700,
                                    width: 3,
                                  ),
                                ),
                              )
                            : null,
                        child: Center(
                          child: Text(
                            'Alimentazione',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: _currentTabIndex == 1
                                  ? Colors.green.shade700
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ClipRect(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    final tween = Tween<Offset>(begin: _slideBeginOffset, end: Offset.zero)
                        .chain(CurveTween(curve: Curves.easeInOut));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                  child: LayoutBuilder(
                    key: ValueKey(_currentTabIndex),
                    builder: (context, constraints) {
                      final tips = _currentTabIndex == 0
                          ? _attivitaFisicaTips
                          : _alimentazioneTips;

                      final bool isLargeScreen = constraints.maxWidth > 600;
                      final double titleFontSize = isLargeScreen ? 24 : 17;
                      final double subtitleFontSize = isLargeScreen ? 18 : 14;
                      final double iconSize = isLargeScreen ? 52 : 40;

                      Widget buildCard(Map<String, String> tip) {
                        return Card(
                          color: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                            leading: SvgPicture.asset(
                              tip['svgAssetPath']!,
                              height: iconSize,
                              width: iconSize,
                              colorFilter: ColorFilter.mode(Colors.green.shade700, BlendMode.srcIn),
                            ),
                            title: Text(
                              tip['title']!,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: titleFontSize, color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                              tip['subtitle']!,
                              style: TextStyle(fontSize: subtitleFontSize, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 167, 167, 167)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      if (isLargeScreen) {
                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 3.5,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: tips.length,
                          itemBuilder: (context, index) => buildCard(tips[index]),
                        );
                      } else {
                        return ListView.builder(
                          itemCount: tips.length,
                          itemBuilder: (context, index) => buildCard(tips[index]),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
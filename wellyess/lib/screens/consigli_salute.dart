import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/base_layout.dart';
import 'consiglio_detail.dart';
import '../utils/consigli_salute_data.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import 'package:wellyess/widgets/tappable_reader.dart';
import 'package:wellyess/services/flutter_tts.dart';

class ConsigliSalutePage extends StatefulWidget {
  const ConsigliSalutePage({super.key});

  @override
  State<ConsigliSalutePage> createState() => _ConsigliSalutePageState();
}

class _ConsigliSalutePageState extends State<ConsigliSalutePage> {
  int _currentTabIndex = 0;
  Offset _slideBeginOffset = const Offset(1.0, 0.0);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Accessibilità
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    // Responsive sizes
    final double horizontalPadding = screenWidth * 0.04;
    final double verticalPadding = screenHeight * 0.015;
    final double titleFontSize = screenWidth * 0.075;
    final double tabFontSize = screenWidth * 0.038;
    final double cardTitleFontSize = screenWidth * 0.043;
    final double cardSubtitleFontSize = screenWidth * 0.035;
    final double iconSize = screenWidth * 0.10;

    // Usa i dati importati
    final tips = _currentTabIndex == 0 ? attivitaFisicaTips : alimentazioneTips;

    return BaseLayout(
      pageTitle: 'Consigli Di Salute',   // ← qui il titolo da annunciare
      onBackPressed: () => Navigator.of(context).pop(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: TappableReader(
                label: 'Titolo pagina Consigli Di Salute',
                child: Text(
                  'Consigli Di Salute',
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const Divider(),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TappableReader(
                      label: 'Tab Attività Fisica',
                      child: InkWell(
                        onTap: () {
                          if (access.talkbackEnabled) {
                            TalkbackService.announce('Attività Fisica');
                          }
                          if (_currentTabIndex == 1) {
                            setState(() {
                              _slideBeginOffset = const Offset(-1.0, 0.0);
                              _currentTabIndex = 0;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                          decoration: _currentTabIndex == 0
                              ? BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: highContrast
                                          ? Colors.black
                                          : Colors.green.shade700,
                                      width: 3,
                                    ),
                                  ),
                                )
                              : null,
                          child: Center(
                            child: Text(
                              'Attività Fisica',
                              style: TextStyle(
                                fontSize: (tabFontSize * fontSizeFactor).clamp(12, 19),
                                color: highContrast
                                    ? Colors.black
                                    : (_currentTabIndex == 0
                                        ? Colors.green.shade700
                                        : Colors.grey.shade600),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TappableReader(
                      label: 'Tab Alimentazione',
                      child: InkWell(
                        onTap: () {
                          if (access.talkbackEnabled) {
                            TalkbackService.announce('Alimentazione');
                          }
                          if (_currentTabIndex == 0) {
                            setState(() {
                              _slideBeginOffset = const Offset(1.0, 0.0);
                              _currentTabIndex = 1;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                          decoration: _currentTabIndex == 1
                              ? BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: highContrast
                                          ? Colors.black
                                          : Colors.green.shade700,
                                      width: 3,
                                    ),
                                  ),
                                )
                              : null,
                          child: Center(
                            child: Text(
                              'Alimentazione',
                              style: TextStyle(
                                fontSize: (tabFontSize * fontSizeFactor).clamp(12, 19),
                                fontWeight: FontWeight.bold,
                                color: highContrast
                                    ? Colors.black
                                    : (_currentTabIndex == 1
                                        ? Colors.green.shade700
                                        : Colors.grey.shade600),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.025),
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
                      final bool isLargeScreen = constraints.maxWidth > 600;
                      final double gridCardAspectRatio = isLargeScreen ? 3.5 : 2.8;

                      Widget buildCard(Map<String, dynamic> tip) {
                        return TappableReader(
                          label: tip['title'] as String,
                          child: Card(
                            color: Colors.white,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: highContrast
                                  ? const BorderSide(color: Colors.black, width: 2)
                                  : BorderSide.none,
                            ),
                            margin: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                              horizontal: screenWidth * 0.01,
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.015,
                                horizontal: screenWidth * 0.04,
                              ),
                              leading: SvgPicture.asset(
                                tip['svgAssetPath']!,
                                height: iconSize * fontSizeFactor,
                                width: iconSize * fontSizeFactor,
                                colorFilter: ColorFilter.mode(
                                  highContrast ? Colors.black : Colors.green.shade700,
                                  BlendMode.srcIn,
                                ),
                              ),
                              title: Text(
                                tip['title']!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: cardTitleFontSize * fontSizeFactor,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              subtitle: Text(
                                tip['subtitle']!,
                                style: TextStyle(
                                  fontSize: cardSubtitleFontSize * fontSizeFactor,
                                  fontWeight: FontWeight.bold,
                                  color: highContrast
                                      ? Colors.grey[800]
                                      : const Color.fromARGB(255, 167, 167, 167),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ConsiglioDetailPage(
                                      title: tip['title']!,
                                      subtitle: tip['subtitle']!,
                                      svgAssetPath: tip['svgAssetPath']!,
                                      description: tip['description'] ?? '',
                                      topics: (tip['topics'] as List).map((e) => Map<String, dynamic>.from(e)).toList(),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }

                      if (isLargeScreen) {
                        return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: gridCardAspectRatio,
                            crossAxisSpacing: screenWidth * 0.02,
                            mainAxisSpacing: screenHeight * 0.01,
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
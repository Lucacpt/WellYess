import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/base_layout.dart';
import 'consiglio_detail.dart';
import '../utils/consigli_salute_data.dart';

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
              child: Text(
                'Consigli Di Salute',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
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
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
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
                              fontSize: tabFontSize,
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
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
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
                              fontSize: tabFontSize,
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
                        return Card(
                          color: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                              height: iconSize,
                              width: iconSize,
                              colorFilter: ColorFilter.mode(Colors.green.shade700, BlendMode.srcIn),
                            ),
                            title: Text(
                              tip['title']!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: cardTitleFontSize,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                              tip['subtitle']!,
                              style: TextStyle(
                                fontSize: cardSubtitleFontSize,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 167, 167, 167),
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
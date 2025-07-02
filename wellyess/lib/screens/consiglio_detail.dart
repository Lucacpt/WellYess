import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/base_layout.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';

class ConsiglioDetailPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String svgAssetPath;
  final String description;
  final List<Map<String, dynamic>> topics;

  const ConsiglioDetailPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.svgAssetPath,
    required this.description,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Accessibilità
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    final double horizontalPadding = screenWidth * 0.04;
    final double verticalPadding = screenHeight * 0.015;
    final double titleFontSize = (screenWidth * 0.075 * fontSizeFactor).clamp(20.0, 36.0);
    final double subtitleFontSize = (screenWidth * 0.045 * fontSizeFactor).clamp(14.0, 28.0);
    final double iconSize = (screenWidth * 0.18 * fontSizeFactor).clamp(40.0, 90.0);
    final double descriptionFontSize = (screenWidth * 0.042 * fontSizeFactor).clamp(13.0, 24.0);
    final double topicTitleFontSize = (screenWidth * 0.048 * fontSizeFactor).clamp(14.0, 26.0);
    final double topicTextFontSize = (screenWidth * 0.041 * fontSizeFactor).clamp(13.0, 22.0);

    return BaseLayout(
      pageTitle: title,                // ← aggiunto
      onBackPressed: () => Navigator.of(context).pop(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: highContrast ? Colors.black : Colors.green.shade900,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.01),
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            SizedBox(height: screenHeight * 0.01),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Icona in cerchio con ombra
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: highContrast ? Colors.yellow.shade100 : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: highContrast
                            ? Border.all(color: Colors.black, width: 2)
                            : null,
                      ),
                      padding: EdgeInsets.all(screenWidth * 0.06),
                      child: SvgPicture.asset(
                        svgAssetPath,
                        height: iconSize,
                        width: iconSize,
                        colorFilter: ColorFilter.mode(
                          highContrast ? Colors.black : Colors.green.shade700,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: highContrast ? Colors.black : Colors.green.shade900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: descriptionFontSize,
                        color: highContrast ? Colors.black : Colors.grey.shade800,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    // Argomenti come card leggere, con elenco puntato se serve
                    ...topics.map((topic) => Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.018),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: highContrast ? Colors.black : Colors.green.shade100,
                            width: 1.5,
                          ),
                        ),
                        color: highContrast ? Colors.yellow.shade100 : Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenHeight * 0.018,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                topic['title'] ?? '',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: topicTitleFontSize,
                                  color: highContrast ? Colors.black : Colors.green.shade700,
                                ),
                              ),
                              SizedBox(height: 6),
                              if (topic['text'] is List)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List<Widget>.from(
                                    (topic['text'] as List).map((item) => Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "• ",
                                          style: TextStyle(
                                            fontSize: topicTextFontSize,
                                            color: highContrast ? Colors.black : Colors.green.shade700,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            item.toString(),
                                            style: TextStyle(
                                              fontSize: topicTextFontSize,
                                              color: highContrast ? Colors.black : Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                  ),
                                )
                              else
                                Text(
                                  topic['text']?.toString() ?? '',
                                  style: TextStyle(
                                    fontSize: topicTextFontSize,
                                    color: highContrast ? Colors.black : Colors.grey.shade800,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    )),
                    SizedBox(height: screenHeight * 0.01),
                    Icon(
                      Icons.info_outline,
                      color: highContrast ? Colors.black : Colors.green.shade700,
                      size: (screenWidth * 0.09 * fontSizeFactor).clamp(24.0, 40.0),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "Segui questo consiglio per migliorare il tuo benessere quotidiano!",
                      style: TextStyle(
                        fontSize: (screenWidth * 0.038 * fontSizeFactor).clamp(12.0, 20.0),
                        color: highContrast ? Colors.black : Colors.green.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
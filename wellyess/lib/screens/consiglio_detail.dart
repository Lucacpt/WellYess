import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/base_layout.dart';

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

    final double horizontalPadding = screenWidth * 0.04;
    final double verticalPadding = screenHeight * 0.015;
    final double titleFontSize = screenWidth * 0.075;
    final double subtitleFontSize = screenWidth * 0.045;
    final double iconSize = screenWidth * 0.18;
    final double descriptionFontSize = screenWidth * 0.042;
    final double topicTitleFontSize = screenWidth * 0.048;
    final double topicTextFontSize = screenWidth * 0.041;

    return BaseLayout(
      onBackPressed: () => Navigator.of(context).pop(),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.01),
            Text(
              title,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.01),
            const Divider(thickness: 1.5),
            SizedBox(height: screenHeight * 0.01),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Icona in cerchio con ombra
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(screenWidth * 0.06),
                      child: SvgPicture.asset(
                        svgAssetPath,
                        height: iconSize,
                        width: iconSize,
                        colorFilter: ColorFilter.mode(Colors.green.shade700, BlendMode.srcIn),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: screenHeight * 0.025),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: descriptionFontSize,
                        color: Colors.grey.shade800,
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
                          side: BorderSide(color: Colors.green.shade100, width: 1),
                        ),
                        color: Colors.white,
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
                                  color: Colors.green.shade700,
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
                                        const Text("• ", style: TextStyle(fontSize: 16)),
                                        Expanded(
                                          child: Text(
                                            item.toString(),
                                            style: TextStyle(
                                              fontSize: topicTextFontSize,
                                              color: Colors.grey.shade800,
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
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    )),
                    SizedBox(height: screenHeight * 0.01),
                    Icon(Icons.info_outline, color: Colors.green.shade700, size: screenWidth * 0.09),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      "Segui questo consiglio per migliorare il tuo benessere quotidiano!",
                      style: TextStyle(
                        fontSize: screenWidth * 0.038,
                        color: Colors.green.shade700,
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
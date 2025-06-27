import 'package:flutter/material.dart';
import '../widgets/base_layout.dart';
import '../widgets/custom_main_button.dart';


class AccessibilitaSection extends StatefulWidget {
  const AccessibilitaSection({super.key});

  @override
  State<AccessibilitaSection> createState() => _AccessibilitaSectionState();
}

class _AccessibilitaSectionState extends State<AccessibilitaSection> {
  double _fontSize = 1.0; // 1.0 = normale, 1.2 = grande, 1.4 = molto grande
  bool _highContrast = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BaseLayout(
      currentIndex: 2,
      onBackPressed: () => Navigator.of(context).pop(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: screenHeight * 0.01),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Accessibilità',
              style: TextStyle(
                fontSize: screenWidth * 0.07,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.025),
          const Divider(),
          // Corpo scorrevole
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Info generale
                    Text(
                      "Personalizza l'app per renderla più accessibile alle tue esigenze.",
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        color: Colors.grey.shade800,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // Dimensione testo
                    Text(
                      'Dimensione testo',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05 * _fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.blue.shade700,
                            size: screenWidth * 0.055),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: Text(
                            "Aumenta la dimensione dei testi per una lettura più facile.",
                            style: TextStyle(
                              fontSize: screenWidth * 0.037,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Slider(
                      value: _fontSize,
                      min: 1.0,
                      max: 1.4,
                      divisions: 2,
                      label: _fontSize == 1.0
                          ? "Normale"
                          : _fontSize == 1.2
                              ? "Grande"
                              : "Molto grande",
                      onChanged: (value) {
                        setState(() {
                          _fontSize = value;
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Contrasto elevato
                    Text(
                      'Contrasto elevato',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05 * _fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.blue.shade700,
                            size: screenWidth * 0.055),
                        SizedBox(width: screenWidth * 0.02),
                        Expanded(
                          child: Text(
                            "Attiva il contrasto elevato per migliorare la visibilità dei testi.",
                            style: TextStyle(
                              fontSize: screenWidth * 0.037,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SwitchListTile(
                      value: _highContrast,
                      title: Text(
                        _highContrast ? "Attivo" : "Disattivo",
                        style: TextStyle(
                          fontSize: screenWidth * 0.045 * _fontSize,
                          color: _highContrast ? Colors.black : Colors.grey.shade700,
                        ),
                      ),
                      activeColor: Colors.black,
                      onChanged: (value) {
                        setState(() {
                          _highContrast = value;
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // Anteprima
                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      decoration: BoxDecoration(
                        color: _highContrast ? Colors.black : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: _highContrast ? Colors.yellow : Colors.grey.shade300,
                          width: 1.2,
                        ),
                      ),
                      child: Text(
                        'Anteprima testo di esempio',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05 * _fontSize,
                          color: _highContrast ? Colors.yellow : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // Salva
                    CustomMainButton(
                      text: 'Salva impostazioni',
                      color: const Color(0xFF5DB47F),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Impostazioni salvate!')),
                        );
                        Navigator.of(context).pop();
                      },
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
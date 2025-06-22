import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/base_layout.dart';

class EmergenzaScreen extends StatefulWidget {
  const EmergenzaScreen({super.key});

  @override
  State<EmergenzaScreen> createState() => _EmergenzaScreenState();
}

class _EmergenzaScreenState extends State<EmergenzaScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool _isFirstTap = false;
  Timer? _resetTapTimer;
  String _buttonText = 'SOS';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _resetTapTimer?.cancel();
    super.dispose();
  }

  void _resetButtonState() {
    if (!mounted) return;
    setState(() {
      _isFirstTap = false;
      _buttonText = 'SOS';
      _animationController.repeat(reverse: true);
    });
  }

  // MODIFICATO: Stile e testo del popup resi più rassicuranti
  Future<void> _showCaregiverNotifiedDialog(
      BuildContext context, double screenWidth, double screenHeight) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(screenWidth * 0.05),
          ),
          contentPadding: EdgeInsets.all(screenWidth * 0.05),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Icona di conferma visiva
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: screenWidth * 0.15,
              ),
              SizedBox(height: screenHeight * 0.02),
              // Testo più rassicurante e informativo
              Text(
                'Richiesta Inviata!\nIl tuo caregiver è stato.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              // Pulsante di chiusura coerente con il messaggio di successo
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Colore cambiato in verde
                  shape: const CircleBorder(),
                  padding: EdgeInsets.all(screenWidth * 0.04),
                ),
                child: Icon(Icons.check, // Icona cambiata in spunta
                    color: Colors.white,
                    size: screenWidth * 0.07),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BaseLayout(
      onBackPressed: () => Navigator.of(context).pop(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
        child: Column(
          children: [
            Text(
              'Emergenza',
              style: TextStyle(
                fontSize: screenWidth * 0.07,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Divider(color: Colors.grey.shade300),
            const Spacer(flex: 2),

            Row(
              children: [
                Icon(Icons.info_outline,
                    color: Colors.blue.shade700, size: screenWidth * 0.06),
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                  child: Text(
                    "Per inviare una richiesta di emergenza, premi il pulsante due volte.",
                    style: TextStyle(
                      fontSize: screenWidth * 0.038,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(flex: 1),

            ScaleTransition(
              scale: _scaleAnimation,
              child: GestureDetector(
                onTap: () {
                  if (!_isFirstTap) {
                    setState(() {
                      _isFirstTap = true;
                      _buttonText = 'Tocca di nuovo\nper confermare';
                      _animationController.stop();
                    });
                    _resetTapTimer?.cancel();
                    _resetTapTimer =
                        Timer(const Duration(seconds: 3), _resetButtonState);
                  } else {
                    _resetTapTimer?.cancel();
                    _showCaregiverNotifiedDialog(
                            context, screenWidth, screenHeight)
                        .then((_) {
                      _resetButtonState();
                    });
                  }
                },
                child: Container(
                  width: screenWidth * 0.7,
                  height: screenWidth * 0.7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Colors.red.shade400, Colors.red.shade800],
                      center: Alignment.center,
                      radius: 0.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.4),
                        spreadRadius: 4,
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _buttonText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _isFirstTap
                            ? screenWidth * 0.07
                            : screenWidth * 0.18,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          const Shadow(
                            blurRadius: 10.0,
                            color: Colors.black38,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(flex: 3),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Azione per "Aggiungi Alla Schermata Di Home"
                },
                icon: Icon(
                  Icons.home_filled,
                  color: Colors.white,
                  size: screenWidth * 0.07,
                ),
                label: Text(
                  'Aggiungi Alla Schermata Di Home',
                  style: TextStyle(
                      color: Colors.white, fontSize: screenWidth * 0.04),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF5DB47F),
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.025,
                      horizontal: screenWidth * 0.04),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  elevation: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
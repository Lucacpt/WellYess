import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/models/user_model.dart';
import '../widgets/base_layout.dart';
import '../widgets/sos_request_card.dart';
import 'package:wellyess/widgets/go_back_button.dart'; // <- importa il BackCircleButton

class EmergenzaScreen extends StatefulWidget {
  const EmergenzaScreen({super.key});

  @override
  State<EmergenzaScreen> createState() => _EmergenzaScreenState();
}

class _EmergenzaScreenState extends State<EmergenzaScreen>
    with SingleTickerProviderStateMixin {
  // --- State per la vista Anziano ---
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isFirstTap = false;
  Timer? _resetTapTimer;
  String _buttonText = 'SOS';

  // --- State per la gestione del tipo utente ---
  UserType? _userType;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserType();

    // Inizializza le animazioni per la vista Anziano
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  Future<void> _loadUserType() async {
    final prefs = await SharedPreferences.getInstance();
    final userTypeString = prefs.getString('userType');
    if (mounted) {
      setState(() {
        if (userTypeString != null) {
          _userType =
              UserType.values.firstWhere((e) => e.toString() == userTypeString);
        }
        _isLoading = false;
      });
    }
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
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: screenWidth * 0.15,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Richiesta Inviata!\nIl tuo caregiver è stato avvisato.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: const CircleBorder(),
                  padding: EdgeInsets.all(screenWidth * 0.04),
                ),
                child: Icon(Icons.check,
                    color: Colors.white, size: screenWidth * 0.07),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BaseLayout(
      userType: _userType,
      // rimuovo onBackPressed: per non duplicare la freccia
      child: _userType == UserType.caregiver
          ? _buildCaregiverView(context)
          : _buildElderView(context),
    );
  }

  // --- NUOVA VISTA PER IL CAREGIVER ---
  Widget _buildCaregiverView(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Richieste di Soccorso',
              style: TextStyle(
                fontSize: screenWidth * 0.07,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(height: 30),
          Text(
            'Nuove Richieste',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade700,
            ),
          ),
          const SizedBox(height: 10),
          const SosRequestCard(
            personName: 'Michele Verdi',
            timestamp: 'Oggi, 14:32',
            isNew: true,
          ),
          const SizedBox(height: 30),
          Text(
            'Storico',
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 10),
          const SosRequestCard(
            personName: 'Michele Verdi',
            timestamp: '12/10/2023',
            isNew: false,
          ),
        ],
      ),
    );
  }

  // --- VISTA ESISTENTE PER L'ANZIANO ---
  Widget _buildElderView(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: sw * 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(   // <-- qui metto freccia e titolo affiancati
            children: [
              BackCircleButton(onPressed: () => Navigator.of(context).pop()),
              SizedBox(width: sw * 0.04),
              Text(
                'Emergenza',
                style: TextStyle(
                  fontSize: sw * 0.07,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: sh * 0.01),
          const Divider(color: Colors.grey),
          SizedBox(height: sh * 0.01),
          Row(
            children: [
              Icon(Icons.info_outline,
                  color: Colors.blue.shade700,
                  size: sw * 0.06),
              SizedBox(width: sw * 0.02),
              Expanded(
                child: Text(
                  "Per inviare una richiesta di emergenza, premi il pulsante due volte.",
                  style: TextStyle(
                    fontSize: sw * 0.038,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(flex: 3),
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
                  _resetTapTimer = Timer(
                      const Duration(seconds: 3), _resetButtonState);
                } else {
                  _resetTapTimer?.cancel();
                  _showCaregiverNotifiedDialog(
                          context, sw, sh)
                      .then((_) {
                    _resetButtonState();
                  });
                }
              },
              child: Container(
                width: sw * 0.55,
                height: sw * 0.55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.red.shade400,
                      Colors.red.shade800
                    ],
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
                          ? sw * 0.07
                          : sw * 0.18,
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
          SizedBox(height: sh * 0.04),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(
                Icons.home_filled,
                color: Colors.white,
                size: sw * 0.07,
              ),
              label: Text(
                'Aggiungi Alla Schermata Di Home',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: sw * 0.04),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFF5DB47F),
                padding: EdgeInsets.symmetric(
                    vertical: sh * 0.025),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(sw * 0.03),
                ),
                elevation: 3,
              ),
            ),
          ),
          SizedBox(height: sh * 0.02),
        ],
      ),
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/models/user_model.dart';
import '../widgets/base_layout.dart';
import '../widgets/sos_request_card.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import '../widgets/pop_up_conferma.dart';
import 'package:wellyess/widgets/tappable_reader.dart';
import 'package:wellyess/services/flutter_tts.dart';

// Schermata principale per la gestione delle emergenze (SOS)
class EmergenzaScreen extends StatefulWidget {
  const EmergenzaScreen({super.key});

  @override
  State<EmergenzaScreen> createState() => _EmergenzaScreenState();
}

class _EmergenzaScreenState extends State<EmergenzaScreen>
    with SingleTickerProviderStateMixin {
  // --- Stato per la vista Anziano (animazione e tap) ---
  late AnimationController _animationController; // Controller per l'animazione del pulsante SOS
  late Animation<double> _scaleAnimation;        // Animazione di scala per il pulsante
  bool _isFirstTap = false;                      // Indica se è stato fatto il primo tap sul pulsante SOS
  Timer? _resetTapTimer;                         // Timer per resettare lo stato del pulsante
  String _buttonText = 'SOS';                    // Testo visualizzato sul pulsante SOS

  // --- Stato per la gestione del tipo utente ---
  UserType? _userType;                           // Tipo utente (caregiver, anziano, ecc.)
  bool _isLoading = true;                        // Stato di caricamento

  @override
  void initState() {
    super.initState();
    _loadUserType(); // Carica il tipo di utente dalle preferenze

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

  // Carica il tipo di utente dalle SharedPreferences
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

  // Resetta lo stato del pulsante SOS dopo un timeout o dopo l'invio
  void _resetButtonState() {
    if (!mounted) return;
    setState(() {
      _isFirstTap = false;
      _buttonText = 'SOS';
      _animationController.repeat(reverse: true);
    });
  }

  // Mostra un popup di conferma dopo l'invio della richiesta SOS
  Future<void> _showCaregiverNotifiedDialog(
      BuildContext context, double screenWidth, double screenHeight) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PopUpConferma(
          message: 'Richiesta Inviata!\nIl tuo caregiver è stato avvisato.',
          onConfirm: () => Navigator.of(dialogContext).pop(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Accessibilità: recupera i valori dal provider
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    if (_isLoading) {
      // Mostra loader se i dati sono in caricamento
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BaseLayout(
      pageTitle: 'Emergenza',              // Titolo della pagina nella barra superiore
      userType: _userType,
      onBackPressed: () => Navigator.of(context).pop(),
      child: _userType == UserType.caregiver
          ? _buildCaregiverView(context, fontSizeFactor, highContrast)
          : _buildElderView(context, fontSizeFactor, highContrast),
    );
  }

  // --- VISTA PER IL CAREGIVER: mostra richieste SOS ricevute e storico ---
  Widget _buildCaregiverView(BuildContext context, double fontSizeFactor, bool highContrast) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // HEADER FISSO: Titolo sezione
        Center(
          child: TappableReader(
            label: 'Titolo sezione Richieste di soccorso',
            child: Text(
              'Richieste di Soccorso',
              style: TextStyle(
                fontSize: (screenWidth * 0.07 * fontSizeFactor).clamp(22.0, 38.0),
                fontWeight: FontWeight.bold,
                color: highContrast ? Colors.black : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Divider(
          height: 30,
          color: highContrast ? Colors.black : Colors.grey,
          thickness: 1.2,
        ),
        // CONTENUTO SCORRIBILE: nuove richieste e storico
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Sottotitolo nuove richieste
                TappableReader(
                  label: 'Sottotitolo Nuove richieste',
                  child: Text(
                    'Nuove Richieste',
                    style: TextStyle(
                      fontSize: (screenWidth * 0.05 * fontSizeFactor).clamp(15.0, 28.0),
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Card richiesta SOS nuova
                const SosRequestCard(
                  personName: 'Michele Verdi',
                  timestamp: 'Oggi, 14:32',
                  isNew: true,
                ),
                const SizedBox(height: 30),
                // Sottotitolo storico richieste
                TappableReader(
                  label: 'Sottotitolo Storico richieste',
                  child: Text(
                    'Storico',
                    style: TextStyle(
                      fontSize: (screenWidth * 0.05 * fontSizeFactor).clamp(15.0, 28.0),
                      fontWeight: FontWeight.bold,
                      color: highContrast ? Colors.black : Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Card richiesta SOS storica
                const SosRequestCard(
                  personName: 'Michele Verdi',
                  timestamp: '12/10/2023',
                  isNew: false,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- VISTA PER L'ANZIANO: pulsante SOS con doppio tap ---
  Widget _buildElderView(BuildContext context, double fontSizeFactor, bool highContrast) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // HEADER FISSO: Titolo pagina
        SizedBox(height: sh * 0.01),
        Center(
          child: TappableReader(
            label: 'Titolo pagina Emergenza',
            child: Text(
              'Emergenza',
              style: TextStyle(
                fontSize: (sw * 0.07 * fontSizeFactor).clamp(22.0, 40.0),
                fontWeight: FontWeight.bold,
                color: highContrast ? Colors.black : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        SizedBox(height: sh * 0.01),
        Divider(
          color: highContrast ? Colors.black : Colors.grey,
          thickness: 1.2,
        ),
        SizedBox(height: sh * 0.01),
        // CONTENUTO SCORRIBILE: istruzioni e pulsante SOS
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Riga informativa su come inviare la richiesta
                  Row(
                    children: [
                      TappableReader(
                        label: 'Icona informativa',
                        child: Icon(Icons.info_outline,
                            color: Colors.blue.shade700,
                            size: (sw * 0.06 * fontSizeFactor).clamp(18.0, 28.0)),
                      ),
                      SizedBox(width: sw * 0.02),
                      Expanded(
                        child: TappableReader(
                          label: 'Istruzioni emergenza: premi due volte per inviare',
                          child: Text(
                            "Per inviare una richiesta di emergenza, premi il pulsante due volte.",
                            style: TextStyle(
                              fontSize: (sw * 0.038 * fontSizeFactor).clamp(15.0, 20.0),
                              fontStyle: FontStyle.italic,
                              color: highContrast ? Colors.black : Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: sh * 0.04),
                  // Pulsante SOS animato con doppio tap per confermare
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: TappableReader(
                      label: _isFirstTap
                          ? 'Conferma invio SOS'
                          : 'Pulsante SOS',
                      child: GestureDetector(
                        onTap: () {
                          if (!_isFirstTap) {
                            // Primo tap: chiede conferma
                            setState(() {
                              _isFirstTap = true;
                              _buttonText = 'Tocca di nuovo\nper confermare';
                              _animationController.stop();
                            });
                            final access = Provider.of<AccessibilitaModel>(context, listen: false);
                            if (access.talkbackEnabled) {
                              TalkbackService.announce('Tocca di nuovo per confermare');
                            }
                            _resetTapTimer?.cancel();
                            _resetTapTimer = Timer(
                                const Duration(seconds: 3), _resetButtonState);
                          } else {
                            // Secondo tap: invia la richiesta
                            _resetTapTimer?.cancel();
                            _showCaregiverNotifiedDialog(context, sw, sh)
                                .then((_) {
                              final access = Provider.of<AccessibilitaModel>(context, listen: false);
                              if (access.talkbackEnabled) {
                                TalkbackService.announce(
                                    'Richiesta inviata. Il caregiver è stato avvisato');
                              }
                              _resetButtonState();
                            });
                          }
                        },
                        child: Container(
                           width: sw * 0.55,
                           height: sw * 0.55,
                           decoration: BoxDecoration(
                             shape: BoxShape.circle,
                             gradient: highContrast
                                 ? null
                                 : RadialGradient(
                                     colors: [
                                       Colors.red.shade400,
                                       Colors.red.shade800
                                     ],
                                     center: Alignment.center,
                                     radius: 0.8,
                                   ),
                             color: highContrast ? Colors.black : null,
                             boxShadow: [
                               BoxShadow(
                                 color: Colors.red.withOpacity(0.4),
                                 spreadRadius: 4,
                                 blurRadius: 15,
                                 offset: const Offset(0, 5),
                               ),
                             ],
                             border: highContrast
                                 ? Border.all(color: Colors.yellow, width: 4)
                                 : null,
                           ),
                           child: Center(
                             child: Text(
                               _buttonText,
                               textAlign: TextAlign.center,
                               style: TextStyle(
                                 color: highContrast ? Colors.yellow : Colors.white,
                                 fontSize: _isFirstTap
                                     ? (sw * 0.07 * fontSizeFactor).clamp(22.0, 32.0)
                                     : (sw * 0.18 * fontSizeFactor).clamp(40.0, 80.0),
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
                   ),
                  SizedBox(height: sh * 0.04),
                  // Bottone per aggiungere la funzione alla schermata home (placeholder)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.home_filled,
                        color: highContrast ? Colors.yellow : Colors.white,
                        size: (sw * 0.07 * fontSizeFactor).clamp(18.0, 32.0),
                      ),
                      label: Text(
                        'Aggiungi Alla Schermata Di Home',
                        style: TextStyle(
                          color: highContrast ? Colors.yellow : Colors.white,
                          fontSize: (sw * 0.04 * fontSizeFactor).clamp(13.0, 20.0),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: highContrast ? Colors.black : const Color(0XFF5DB47F),
                        padding: EdgeInsets.symmetric(
                            vertical: sh * 0.025),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(sw * 0.03),
                          side: highContrast
                              ? const BorderSide(color: Colors.yellow, width: 2)
                              : BorderSide.none,
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
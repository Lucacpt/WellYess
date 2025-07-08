import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // per MethodChannel
import 'package:flutter_tts/flutter_tts.dart';
import '../widgets/custom_main_button.dart';
import '../widgets/base_layout.dart';
import 'package:provider/provider.dart';
import 'package:wellyess/models/accessibilita_model.dart';
import 'package:wellyess/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellyess/services/flutter_tts.dart';
import 'package:wellyess/widgets/tappable_reader.dart';

class AccessibilitaSection extends StatefulWidget {
  const AccessibilitaSection({super.key});

  @override
  State<AccessibilitaSection> createState() => _AccessibilitaSectionState();
}

class _AccessibilitaSectionState extends State<AccessibilitaSection> {
  // Canale per comunicare con la piattaforma nativa (Android)
  static const _channel = MethodChannel('wellyess/accessibility');

  late final FlutterTts _tts; // Text-to-speech
  double _fontSize = 1.0; // Fattore di scala per la dimensione del testo
  bool _highContrast = false; // Stato del contrasto elevato
  UserType? _userType; // Tipo utente (es. caregiver, anziano)
  bool _isLoading = true; // Stato di caricamento
  bool _isReading = false; // Se la sintesi vocale è attiva

  @override
  void initState() {
    super.initState();
    _tts = FlutterTts();
    _tts.setLanguage('it-IT');
    _tts.setSpeechRate(0.5);
    // Sincronizza i valori locali con quelli globali del provider dopo il primo frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final access = context.read<AccessibilitaModel>();
      setState(() {
        _fontSize = access.fontSizeFactor;
        _highContrast = access.highContrast;
      });
    });
    _loadUserType();
  }

  // Carica il tipo di utente dalle preferenze condivise
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

  /// 1) Controlla se un servizio di Accessibilità (p.es. TalkBack) è abilitato
  Future<bool> _isAccessibilityEnabled() async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod<bool>('isAccessibilityEnabled') ?? false;
    } catch (_) {
      return false;
    }
  }

  // Apre le impostazioni di accessibilità del sistema operativo
  void _openAccessibilitySettings() {
    if (Platform.isAndroid) {
      _channel.invokeMethod('openAccessibilitySettings');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
            Text('Apri Impostazioni → Accessibilità per attivare VoiceOver.'),
        ),
      );
    }
  }

  // Attiva/disattiva la lettura vocale della pagina
  Future<void> _toggleTalkBack() async {
    if (_isReading) {
      await _tts.stop();
      setState(() => _isReading = false);
    } else {
      final summary = StringBuffer()
        ..write('Pagina Accessibilità. ')
        ..write('Dimensione testo ${_fontSize == 1.0 ? 'normale' : _fontSize == 1.2 ? 'grande' : 'molto grande'}. ')
        ..write('Contrasto elevato ${_highContrast ? 'attivo' : 'disattivo'}.')
        ..write('Puoi modificare queste impostazioni direttamente nell\'app.');
      await _tts.speak(summary.toString());
      setState(() => _isReading = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ottieni dimensioni schermo per layout responsivo
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // Provider per accessibilità
    final access = context.watch<AccessibilitaModel>();
    final fontSizeFactor = access.fontSizeFactor;
    final highContrast = access.highContrast;

    // Mostra loader se i dati sono in caricamento
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return BaseLayout(
      pageTitle: 'Accessibilità',
      currentIndex: 2,
      userType: _userType,
      onBackPressed: () => Navigator.of(context).pop(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: screenHeight * 0.01),
          // Titolo pagina con lettura vocale
          Align(
            alignment: Alignment.center,
            child: TappableReader(
              label: 'Titolo pagina Accessibilità',
              child: Text(
                'Accessibilità',
                style: TextStyle(
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.025),
          const Divider(),
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
                    // Descrizione generale
                    TappableReader(
                      label: 'Testo introduttivo personalizzazione',
                      child: Text(
                        "Personalizza l'app per renderla più accessibile alle tue esigenze.",
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: Colors.grey.shade800,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // Sezione per la dimensione del testo
                    TappableReader(
                      label: 'Dimensione testo',
                      child: Text(
                        'Dimensione testo',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05 * _fontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Row(
                      children: [
                        // Icona informativa
                        TappableReader(
                          label: "Icona info",
                          child: Icon(Icons.info_outline,
                              color: Colors.blue.shade700,
                              size: screenWidth * 0.055),
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        // Testo descrittivo
                        Expanded(
                          child: TappableReader(
                            label: "Aumenta la dimensione dei testi per una lettura più facile.",
                            child: Text(
                              "Aumenta la dimensione dei testi per una lettura più facile.",
                              style: TextStyle(
                                fontSize: screenWidth * 0.037,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Slider per regolare la dimensione del testo
                    TappableReader(
                      label: 'Slider Dimensione testo valore ${_fontSize == 1.0 ? 'Normale' : _fontSize == 1.2 ? 'Grande' : 'Molto grande'}',
                      child: Slider(
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
                          // Aggiorna il valore globale nel provider
                          context.read<AccessibilitaModel>().setFontSize(value);
                        },
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Contrasto elevato (richiede doppio tap se TalkBack attivo)
                    TappableReader(
                      label: access.highContrast
                        ? 'Interruttore Contrasto elevato attivo'
                        : 'Interruttore Contrasto elevato disattivo',
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onDoubleTap: () {
                          final newValue = !access.highContrast;
                          context.read<AccessibilitaModel>().setHighContrast(newValue);
                          if (access.talkbackEnabled) {
                            TalkbackService.announce(
                              newValue
                                ? 'Contrasto elevato attivato'
                                : 'Contrasto elevato disattivato',
                            );
                          }
                        },
                        child: SwitchListTile(
                          title: Text(
                            'Contrasto elevato',
                            style: TextStyle(fontSize: screenWidth * 0.05 * fontSizeFactor),
                          ),
                          value: access.highContrast,
                          // Disabilita il toggle al singolo tap se TalkBack è attivo
                          onChanged: access.talkbackEnabled
                            ? null
                            : (v) => context.read<AccessibilitaModel>().setHighContrast(v),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // TalkBack: switch per attivare/disattivare la lettura vocale
                    TappableReader(
                      label: access.talkbackEnabled
                        ? 'Interruttore TalkBack attivo'
                        : 'Interruttore TalkBack disattivo',
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onDoubleTap: () async {
                          final newValue = !access.talkbackEnabled;
                          access.setTalkbackEnabled(newValue);
                          if (!newValue) {
                            await TalkbackService.stop();
                          } else {
                            await TalkbackService.announce(
                              'TalkBack attivato. Ora doppio tap su ogni area per leggerla.',
                            );
                          }
                        },
                        child: SwitchListTile(
                          title: Text(
                            'TalkBack',
                            style: TextStyle(fontSize: screenWidth * 0.05 * fontSizeFactor),
                          ),
                          value: access.talkbackEnabled,
                          onChanged: access.talkbackEnabled
                            ? null
                            : (v) async {
                                access.setTalkbackEnabled(v);
                                if (v) {
                                  await TalkbackService.announce(
                                    'TalkBack attivato. Ora doppio tap su ogni area per leggerla.',
                                  );
                                }
                              },
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // Anteprima del testo con le impostazioni correnti
                    Semantics(
                      label: 'Anteprima testo di esempio',
                      readOnly: true,
                      child: Container(
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
                    ),
                    SizedBox(height: screenHeight * 0.04),

                    // Bottone per salvare le impostazioni
                    TappableReader(
                      label: 'Bottone Salva impostazioni accessibilità',
                      child: CustomMainButton(
                        text: 'Salva impostazioni',
                        color: const Color(0xFF5DB47F),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Impostazioni salvate!')),
                          );
                          Navigator.of(context).pop();
                        },
                      ),
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
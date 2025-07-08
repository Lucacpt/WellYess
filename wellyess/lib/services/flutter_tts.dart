import 'package:flutter_tts/flutter_tts.dart';

/// Servizio singleton per gestire il TTS “TalkBack” globale
class TalkbackService {
  // Istanza privata di FlutterTts configurata per lingua italiana e velocità media
  static final _tts = FlutterTts()
    ..setLanguage('it-IT')
    ..setSpeechRate(0.5);

  static bool _reading = false; // Indica se è in corso una lettura

  /// Legge [text], interrompendo eventuali letture in corso
  static Future<void> announce(String text) async {
    if (_reading) await _tts.stop(); // Ferma la lettura precedente se attiva
    _reading = true;                 // Segna che la lettura è in corso
    await _tts.speak(text);          // Avvia la lettura del testo
  }

  /// Ferma la lettura
  static Future<void> stop() async {
    if (!_reading) return; // Se non sta leggendo, non fa nulla
    _reading = false;      // Segna che la lettura è terminata
    await _tts.stop();     // Ferma il TTS
  }
}
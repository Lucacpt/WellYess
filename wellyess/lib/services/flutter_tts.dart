import 'package:flutter_tts/flutter_tts.dart';

/// Servizio singleton per gestire il TTS “TalkBack” globale
class TalkbackService {
  static final _tts = FlutterTts()
    ..setLanguage('it-IT')
    ..setSpeechRate(0.5);
  static bool _reading = false;

  /// Legge [text], interrompendo eventuali letture in corso
  static Future<void> announce(String text) async {
    if (_reading) await _tts.stop();
    _reading = true;
    await _tts.speak(text);
  }

  /// Ferma la lettura
  static Future<void> stop() async {
    if (!_reading) return;
    _reading = false;
    await _tts.stop();
  }
}
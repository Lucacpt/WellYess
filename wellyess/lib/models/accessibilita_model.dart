import 'package:flutter/material.dart';

class AccessibilitaModel extends ChangeNotifier {
  double _fontSizeFactor = 1.0;
  bool _highContrast = false;
  bool _talkbackEnabled = false;

  double get fontSizeFactor => _fontSizeFactor;
  bool get highContrast => _highContrast;
  bool get talkbackEnabled => _talkbackEnabled;

  AccessibilitaModel({double fontSizeFactor = 1.0, bool highContrast = false})
      : _fontSizeFactor = fontSizeFactor,
        _highContrast = highContrast;

  void setFontSize(double factor) {
    _fontSizeFactor = factor;
    notifyListeners();
  }

  void setHighContrast(bool value) {
    _highContrast = value;
    notifyListeners();
  }

  void setTalkbackEnabled(bool v) {
    _talkbackEnabled = v;
    notifyListeners();
  }
}
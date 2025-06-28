import 'package:flutter/material.dart';

class AccessibilitaModel extends ChangeNotifier {
  double fontSizeFactor;
  bool highContrast;

  AccessibilitaModel({this.fontSizeFactor = 1.0, this.highContrast = false});

  void setFontSize(double factor) {
    fontSizeFactor = factor;
    notifyListeners();
  }

  void setHighContrast(bool value) {
    highContrast = value;
    notifyListeners();
  }
}
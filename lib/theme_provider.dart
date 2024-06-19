import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  bool isDarkMode = false; // Default to light mode

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  ThemeData currentTheme() {
    return isDarkMode ? ThemeData.light() : ThemeData.dark();
  }

  void setToDefault() {}
}

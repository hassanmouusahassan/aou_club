import 'package:flutter/material.dart';

import 'theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = AppThemes.darkTheme;

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme(bool value) {
    _currentTheme =
        (_currentTheme == AppThemes.darkTheme) ? AppThemes.lightTheme : AppThemes.darkTheme;
    notifyListeners();
  }
}

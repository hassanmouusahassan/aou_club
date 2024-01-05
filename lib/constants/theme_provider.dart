import 'package:flutter/material.dart';

import 'theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = AppThemes.lightTheme;

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    _currentTheme =
        (_currentTheme == AppThemes.lightTheme) ? AppThemes.darkTheme : AppThemes.lightTheme;
    notifyListeners();
  }
}

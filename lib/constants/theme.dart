import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color.fromARGB(255, 194, 199, 204), // Customize colors as needed
    // Add more theme configurations
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    primaryColor: Color.fromARGB(255, 51, 50, 50), // Customize colors as needed
    // Add more theme configurations
  );
}

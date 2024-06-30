import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    scrolledUnderElevation: 0.0,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF3CA9FC),
    onPrimary: Colors.white,
    secondary: Color.fromRGBO(168, 193, 210, 0.25098039215686274),
    tertiary: Color(0xFFEE4667),
    inversePrimary: Color(0xFF757575),
    inverseSurface: Colors.black87,
    onInverseSurface: Colors.black26,
    surfaceContainer: Color(0xFFE0E0E0),
  ),
);
import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    scrolledUnderElevation: 0.0,
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF3CA9FC),
    onPrimary: Colors.white,
    secondary: Color.fromRGBO(168, 193, 210, 0.25098039215686274),
    tertiary: Color(0xFFEE4667),
    inversePrimary: Color(0xFF757575),
    inverseSurface: Color(0xFFEEEEEE),
    onInverseSurface: Color(0xFFF5F5F5),
    surfaceContainer: Color(0xFFE0E0E0),
  ),
);
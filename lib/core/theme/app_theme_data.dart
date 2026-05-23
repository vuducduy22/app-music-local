import 'package:flutter/material.dart';

/// Theme M0 — dark mặc định theo [DESIGN_SYSTEM.md] §5.
ThemeData buildAppDarkTheme() {
  const surface = Color(0xFF0A0A0A);
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFAFAFA),
      onPrimary: Color(0xFF0A0A0A),
      secondary: Color(0xFFB0B0B0),
      surface: surface,
      onSurface: Color(0xFFF5F5F5),
      onSurfaceVariant: Color(0xFFB0B0B0),
      outline: Color(0xFF2A2A2A),
      error: Color(0xFFEF5350),
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: surface,
  );
}

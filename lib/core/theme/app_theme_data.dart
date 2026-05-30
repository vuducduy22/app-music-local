import 'package:flutter/material.dart';

import '../widgets/app_ambient_background.dart';

/// Theme M0 — dark mặc định theo [DESIGN_SYSTEM.md] §5.
ThemeData buildAppDarkTheme() {
  const surface = Color(0xFF161622);
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
      outline: Color(0xFF2E2E3A),
      error: Color(0xFFEF5350),
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.transparent,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppAmbientBackground.baseMid.withValues(alpha: 0.82),
      indicatorColor: Colors.white.withValues(alpha: 0.10),
      elevation: 0,
      height: 64,
    ),
    dividerColor: Colors.white.withValues(alpha: 0.08),
  );
}

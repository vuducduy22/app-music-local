import 'package:flutter/material.dart';

/// Gradient nền Player — xem [DESIGN_SYSTEM.md] §6.4.
class PlayerGradient {
  const PlayerGradient._();

  static const darkNoArt = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF4A148C), Color(0xFF0A0A0A)],
  );

  static LinearGradient fromColor(Color top, {required bool isDark}) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        top,
        isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF5F5F5),
      ],
    );
  }

  static LinearGradient primaryFallback(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return fromColor(
      scheme.primary.withValues(alpha: 0.2),
      isDark: Theme.of(context).brightness == Brightness.dark,
    );
  }
}

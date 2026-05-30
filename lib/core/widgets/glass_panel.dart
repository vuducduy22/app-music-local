import 'dart:ui';

import 'package:flutter/material.dart';

/// Panel kính mờ — blur nền phía sau + viền sáng nhẹ.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.borderRadius = BorderRadius.zero,
    this.blurSigma = 12,
    this.tintColor,
    this.borderColor,
    this.padding,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final double blurSigma;
  final Color? tintColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tint = tintColor ??
        (isDark
            ? Colors.black.withValues(alpha: 0.36)
            : Colors.white.withValues(alpha: 0.52));
    final border = borderColor ??
        Colors.white.withValues(alpha: isDark ? 0.16 : 0.34);

    final content = padding != null ? Padding(padding: padding!, child: child) : child;

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Stack(
          children: [
            Positioned.fill(child: ColoredBox(color: tint)),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: isDark ? 0.12 : 0.24),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                    stops: const [0.0, 0.5],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border(
                    top: BorderSide(color: border, width: 0.8),
                    left: BorderSide(
                      color: border.withValues(alpha: border.a * 0.55),
                    ),
                    right: BorderSide(
                      color: border.withValues(alpha: border.a * 0.55),
                    ),
                  ),
                ),
              ),
            ),
            content,
          ],
        ),
      ),
    );
  }
}

/// Lớp kính trang trí — không blur, dùng trên placeholder/ảnh nhỏ.
class GlassSheen extends StatelessWidget {
  const GlassSheen({
    super.key,
    required this.borderRadius,
    this.intensity = 1,
  });

  final BorderRadius borderRadius;
  final double intensity;

  @override
  Widget build(BuildContext context) {
    final t = intensity.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.28 * t),
                  Colors.white.withValues(alpha: 0.06 * t),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.28, 0.72],
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.30 * t),
                width: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Khung kính quanh ảnh bìa lớn trên Player.
class GlassArtworkFrame extends StatelessWidget {
  const GlassArtworkFrame({
    super.key,
    required this.child,
    this.borderRadius = 12,
  });

  final Widget child;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        children: [
          child,
          Positioned.fill(
            child: GlassSheen(
              borderRadius: BorderRadius.circular(borderRadius),
              intensity: 0.85,
            ),
          ),
        ],
      ),
    );
  }
}

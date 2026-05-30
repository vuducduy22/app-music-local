import 'package:flutter/material.dart';

/// Nền ambient tối — gradient + glow nhẹ cho màn minimal (Library, Settings, …).
class AppAmbientBackground extends StatelessWidget {
  const AppAmbientBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  static const baseTop = Color(0xFF14141F);
  static const baseMid = Color(0xFF0C0C12);
  static const baseBottom = Color(0xFF101018);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [baseTop, baseMid, baseBottom],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _GlowSpot(
            top: -80,
            right: -60,
            size: 300,
            color: const Color(0xFF5B3A8C).withValues(alpha: 0.22),
          ),
          _GlowSpot(
            bottom: 120,
            left: -100,
            size: 280,
            color: const Color(0xFF1E3A5F).withValues(alpha: 0.20),
          ),
          _GlowSpot(
            top: 220,
            left: 40,
            size: 180,
            color: const Color(0xFF3D2C4A).withValues(alpha: 0.12),
          ),
          child,
        ],
      ),
    );
  }
}

class _GlowSpot extends StatelessWidget {
  const _GlowSpot({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.size,
    required this.color,
  });

  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color, Colors.transparent],
            ),
          ),
        ),
      ),
    );
  }
}

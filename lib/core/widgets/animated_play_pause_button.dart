import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Nút play/pause — pulse nhẹ + thanh pause động khi đang phát.
class AnimatedPlayPauseButton extends StatefulWidget {
  const AnimatedPlayPauseButton({
    super.key,
    required this.playing,
    this.onPressed,
    this.iconSize = 24,
  });

  final bool playing;
  final VoidCallback? onPressed;
  final double iconSize;

  @override
  State<AnimatedPlayPauseButton> createState() =>
      _AnimatedPlayPauseButtonState();
}

class _AnimatedPlayPauseButtonState extends State<AnimatedPlayPauseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _syncAnimation();
  }

  @override
  void didUpdateWidget(covariant AnimatedPlayPauseButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playing != widget.playing) {
      _syncAnimation();
    }
  }

  void _syncAnimation() {
    if (widget.playing) {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    } else {
      _controller
        ..stop()
        ..reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;

    return IconButton(
      onPressed: widget.onPressed,
      iconSize: widget.iconSize,
      icon: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          if (!widget.playing) {
            return Icon(
              Icons.play_arrow,
              size: widget.iconSize,
              color: color,
            );
          }

          final t = _controller.value * 2 * math.pi;
          final pulse = 1 + 0.05 * math.sin(t);
          final glowAlpha = 0.10 + 0.08 * ((math.sin(t) + 1) / 2);

          return SizedBox(
            width: widget.iconSize,
            height: widget.iconSize,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Transform.scale(
                  scale: pulse * 1.35,
                  child: Container(
                    width: widget.iconSize,
                    height: widget.iconSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: glowAlpha),
                    ),
                  ),
                ),
                _AnimatedPauseBars(
                  size: widget.iconSize * 0.52,
                  phase: t,
                  color: color,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedPauseBars extends StatelessWidget {
  const _AnimatedPauseBars({
    required this.size,
    required this.phase,
    required this.color,
  });

  final double size;
  final double phase;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final barWidth = size * 0.28;
    final gap = size * 0.22;
    final baseHeight = size * 0.88;

    final leftH = baseHeight * (0.82 + 0.18 * ((math.sin(phase) + 1) / 2));
    final rightH =
        baseHeight * (0.82 + 0.18 * ((math.sin(phase + 1.4) + 1) / 2));

    Widget bar(double height) {
      return Container(
        width: barWidth,
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(barWidth / 2),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        bar(leftH),
        SizedBox(width: gap),
        bar(rightH),
      ],
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Icon equalizer 4 cột — animation khi đang phát.
class PlayingEqualizerIcon extends StatefulWidget {
  const PlayingEqualizerIcon({
    super.key,
    required this.size,
    this.color,
    this.barCount = 4,
  });

  final double size;
  final Color? color;
  final int barCount;

  @override
  State<PlayingEqualizerIcon> createState() => _PlayingEqualizerIconState();
}

class _PlayingEqualizerIconState extends State<PlayingEqualizerIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Colors.white.withValues(alpha: 0.92);
    final count = widget.barCount;
    final gap = widget.size * 0.07;
    final barWidth = (widget.size - (count - 1) * gap) / count;
    final maxHeight = widget.size * 0.62;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value * 2 * math.pi;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(count, (index) {
              final phase = index * 1.35;
              final wave = (math.sin(t + phase) + 1) / 2;
              final height = maxHeight * (0.28 + 0.72 * wave);
              return Container(
                width: barWidth,
                height: height,
                margin: EdgeInsets.only(left: index == 0 ? 0 : gap),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(barWidth / 2),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

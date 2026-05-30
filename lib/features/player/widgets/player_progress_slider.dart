import 'package:flutter/material.dart';

import '../../../core/utils/duration_format.dart';

/// Thanh tua — state kéo tách riêng, không rebuild cả màn Player.
class PlayerProgressSlider extends StatefulWidget {
  const PlayerProgressSlider({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> onSeek;

  @override
  State<PlayerProgressSlider> createState() => _PlayerProgressSliderState();
}

class _PlayerProgressSliderState extends State<PlayerProgressSlider> {
  double? _dragValue;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final maxMs = widget.duration.inMilliseconds;
    final enabled = maxMs > 0;
    final maxProgress = enabled ? maxMs.toDouble() : 1.0;
    final positionMs = widget.position.inMilliseconds
        .clamp(0, maxMs > 0 ? maxMs : 0)
        .toDouble();
    final sliderValue =
        (_dragValue ?? positionMs).clamp(0.0, maxProgress).toDouble();

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
          ),
          child: Slider(
            value: sliderValue,
            max: maxProgress,
            onChangeStart: enabled
                ? (_) => setState(() => _isDragging = true)
                : null,
            onChanged: enabled
                ? (value) => setState(() => _dragValue = value.toDouble())
                : null,
            onChangeEnd: enabled
                ? (value) {
                    widget.onSeek(Duration(milliseconds: value.round()));
                    setState(() {
                      _isDragging = false;
                      _dragValue = value;
                    });
                  }
                : null,
            activeColor: Colors.white,
            inactiveColor: Colors.white24,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDuration(Duration(milliseconds: sliderValue.round())),
                style: const TextStyle(
                  color: Colors.white70,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              Text(
                formatDuration(widget.duration),
                style: const TextStyle(
                  color: Colors.white70,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(covariant PlayerProgressSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isDragging &&
        _dragValue != null &&
        (widget.position.inMilliseconds - _dragValue!.round()).abs() < 1200) {
      setState(() => _dragValue = null);
    }
  }
}

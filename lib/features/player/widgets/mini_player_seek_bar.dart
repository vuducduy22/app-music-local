import 'package:flutter/material.dart';

/// Viền trên mini player = thanh tiến trình (embedded trong panel).
class MiniPlayerSeekBar extends StatefulWidget {
  const MiniPlayerSeekBar({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
  });

  final Duration position;
  final Duration duration;
  final ValueChanged<Duration> onSeek;

  static const borderHeight = 2.0;
  static const hitZoneHeight = 22.0;

  @override
  State<MiniPlayerSeekBar> createState() => _MiniPlayerSeekBarState();
}

class _MiniPlayerSeekBarState extends State<MiniPlayerSeekBar> {
  double? _dragFraction;
  bool _isDragging = false;

  static const _thumbSize = 13.0;
  static const _thumbSizeDragging = 16.0;

  double _progressFrom(Duration position) {
    final maxMs = widget.duration.inMilliseconds;
    if (maxMs <= 0) return 0;
    return (position.inMilliseconds / maxMs).clamp(0.0, 1.0);
  }

  void _seekToFraction(double fraction, {required bool commit}) {
    final maxMs = widget.duration.inMilliseconds;
    if (maxMs <= 0) return;
    final clamped = fraction.clamp(0.0, 1.0);
    setState(() => _dragFraction = clamped);
    if (commit) {
      widget.onSeek(Duration(milliseconds: (maxMs * clamped).round()));
      setState(() {
        _isDragging = false;
        _dragFraction = null;
      });
    }
  }

  void _updateFromDx(double dx, double width, {required bool commit}) {
    if (width <= 0) return;
    _seekToFraction(dx / width, commit: commit);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.duration.inMilliseconds > 0;
    final progress = enabled
        ? (_dragFraction ?? _progressFrom(widget.position))
        : 0.0;
    final scheme = Theme.of(context).colorScheme;
    final activeColor = scheme.primary;
    final inactiveColor = scheme.onSurface.withValues(alpha: 0.10);
    final thumbSize = _isDragging ? _thumbSizeDragging : _thumbSize;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final thumbLeft =
            (progress * width - thumbSize / 2).clamp(0.0, width - thumbSize);
        final thumbTop =
            (MiniPlayerSeekBar.borderHeight - thumbSize) / 2;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: enabled
              ? (details) {
                  setState(() => _isDragging = true);
                  _updateFromDx(details.localPosition.dx, width, commit: true);
                }
              : null,
          onHorizontalDragStart: enabled
              ? (_) => setState(() => _isDragging = true)
              : null,
          onHorizontalDragUpdate: enabled
              ? (details) =>
                  _updateFromDx(details.localPosition.dx, width, commit: false)
              : null,
          onHorizontalDragEnd: enabled
              ? (_) {
                  if (_dragFraction != null) {
                    widget.onSeek(
                      Duration(
                        milliseconds: (widget.duration.inMilliseconds *
                                _dragFraction!)
                            .round(),
                      ),
                    );
                  }
                  setState(() {
                    _isDragging = false;
                    _dragFraction = null;
                  });
                }
              : null,
          child: SizedBox(
            height: MiniPlayerSeekBar.hitZoneHeight,
            width: double.infinity,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: MiniPlayerSeekBar.borderHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ColoredBox(color: inactiveColor),
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: progress.clamp(0.0, 1.0),
                        child: ColoredBox(color: activeColor),
                      ),
                    ],
                  ),
                ),
                if (enabled)
                  Positioned(
                    left: thumbLeft,
                    top: thumbTop,
                    child: _MusicSeekThumb(
                      size: thumbSize,
                      isDragging: _isDragging,
                      foreground: scheme.onPrimary,
                      background: activeColor,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void didUpdateWidget(covariant MiniPlayerSeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isDragging &&
        _dragFraction != null &&
        widget.duration.inMilliseconds > 0) {
      final diffMs = (widget.position.inMilliseconds -
              _dragFraction! * widget.duration.inMilliseconds)
          .abs();
      if (diffMs < 1200) {
        setState(() => _dragFraction = null);
      }
    }
  }
}

class _MusicSeekThumb extends StatelessWidget {
  const _MusicSeekThumb({
    required this.size,
    required this.isDragging,
    required this.foreground,
    required this.background,
  });

  final double size;
  final bool isDragging;
  final Color foreground;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isDragging ? 1.1 : 1,
      duration: const Duration(milliseconds: 120),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: background,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.9),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDragging ? 0.4 : 0.25),
              blurRadius: isDragging ? 5 : 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Icon(
          Icons.music_note_rounded,
          size: size * 0.55,
          color: foreground,
        ),
      ),
    );
  }
}

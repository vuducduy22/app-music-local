import 'dart:io';

import 'package:flutter/material.dart';

import 'glass_panel.dart';

/// Placeholder khi track không có ảnh bìa — gradient theo bài + initial/icon.
class TrackArtworkPlaceholder extends StatelessWidget {
  const TrackArtworkPlaceholder({
    super.key,
    required this.seed,
    this.label,
    this.size = 48,
    this.borderRadius = 8,
    this.playing = false,
  });

  /// URI hoặc id ổn định để sinh màu gradient.
  final String seed;

  /// Tên hiển thị — dùng chữ cái đầu; null thì dùng icon.
  final String? label;
  final double size;
  final double borderRadius;
  final bool playing;

  @override
  Widget build(BuildContext context) {
    final colors = _gradientColors(seed);
    final initial = _initialFrom(label);
    final useInitial = initial != null;
    final iconSize = size * (useInitial ? 0.42 : 0.46);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.last.withValues(alpha: 0.35),
                  blurRadius: size * 0.08,
                  offset: Offset(0, size * 0.04),
                ),
              ],
            ),
          ),
          GlassSheen(
            borderRadius: BorderRadius.circular(borderRadius),
            intensity: size >= 64 ? 0.9 : 0.75,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              if (useInitial)
                Positioned(
                  right: size * 0.12,
                  bottom: size * 0.1,
                  child: Icon(
                    Icons.album_outlined,
                    size: iconSize * 0.45,
                    color: Colors.white.withValues(alpha: 0.22),
                  ),
                ),
              if (playing)
                Icon(
                  Icons.graphic_eq_rounded,
                  size: iconSize,
                  color: Colors.white.withValues(alpha: 0.92),
                )
              else if (useInitial)
                Text(
                  initial,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: iconSize,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                )
              else
                Icon(
                  Icons.album_outlined,
                  size: iconSize,
                  color: Colors.white.withValues(alpha: 0.88),
                ),
            ],
          ),
        ],
      ),
    );
  }

  static List<Color> gradientColorsFor(String seed) => _gradientColors(seed);

  static List<Color> _gradientColors(String seed) {
    final hash = seed.hashCode.abs();
    final hue = (hash % 360).toDouble();
    return [
      HSLColor.fromAHSL(1, hue, 0.52, 0.42).toColor(),
      HSLColor.fromAHSL(1, (hue + 36) % 360, 0.48, 0.30).toColor(),
    ];
  }

  static String? _initialFrom(String? label) {
    final trimmed = label?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed.characters.first.toUpperCase();
  }
}

/// Ảnh bìa track — file hoặc placeholder.
class TrackArtwork extends StatelessWidget {
  const TrackArtwork({
    super.key,
    required this.trackSeed,
    this.artCachePath,
    this.displayTitle,
    this.size = 48,
    this.borderRadius = 8,
    this.playing = false,
    this.cacheSize,
  });

  final String trackSeed;
  final String? artCachePath;
  final String? displayTitle;
  final double size;
  final double borderRadius;
  final bool playing;
  final int? cacheSize;

  @override
  Widget build(BuildContext context) {
    final path = artCachePath;
    if (path != null && File(path).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.file(
          File(path),
          width: size,
          height: size,
          fit: BoxFit.cover,
          cacheWidth: cacheSize,
          cacheHeight: cacheSize,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) => _placeholder(),
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return TrackArtworkPlaceholder(
      seed: trackSeed,
      label: displayTitle,
      size: size,
      borderRadius: borderRadius,
      playing: playing,
    );
  }
}

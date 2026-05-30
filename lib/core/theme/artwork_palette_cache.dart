import 'dart:io';

import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../domain/models/track.dart';
import 'player_gradient.dart';

/// Cache gradient Player theo ảnh bìa — tính sớm khi bài đang phát.
class ArtworkPaletteCache {
  ArtworkPaletteCache._();

  static final ArtworkPaletteCache instance = ArtworkPaletteCache._();

  final Map<String, LinearGradient> _gradients = {};
  final Map<String, Future<LinearGradient?>> _pending = {};

  String _key(String artPath, bool isDark) => '$artPath|$isDark';

  LinearGradient? gradientFor(String? artPath, {required bool isDark}) {
    if (artPath == null) return null;
    return _gradients[_key(artPath, isDark)];
  }

  Future<LinearGradient?> warmTrack(Track? track, {required bool isDark}) {
    final artPath = track?.artCachePath;
    if (artPath == null) return Future.value(null);

    final key = _key(artPath, isDark);
    final cached = _gradients[key];
    if (cached != null) return Future.value(cached);

    return _pending.putIfAbsent(key, () async {
      try {
        final file = File(artPath);
        if (!file.existsSync()) return null;

        final palette = await PaletteGenerator.fromImageProvider(
          FileImage(file),
          size: const Size(48, 48),
          maximumColorCount: 4,
        );
        final color = palette.dominantColor?.color;
        if (color == null) return null;

        final gradient = PlayerGradient.fromColor(color, isDark: isDark);
        _gradients[key] = gradient;
        return gradient;
      } catch (_) {
        return null;
      } finally {
        _pending.remove(key);
      }
    });
  }

  void evict(String artPath) {
    _gradients.removeWhere((key, _) => key.startsWith('$artPath|'));
    _pending.removeWhere((key, _) => key.startsWith('$artPath|'));
  }
}

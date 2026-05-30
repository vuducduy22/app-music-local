import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../core/theme/artwork_palette_cache.dart';
import '../../core/theme/player_gradient.dart';
import '../../core/widgets/glass_panel.dart';
import '../../core/widgets/track_artwork.dart';
import '../../domain/enums/repeat_mode.dart' as app;
import '../../domain/models/track.dart';
import 'player_view_model.dart';
import 'widgets/player_progress_slider.dart';

/// Màn phát đầy đủ — xem [player.md].
class PlayerScreen extends StatefulWidget {
  const PlayerScreen({
    super.key,
    required this.viewModel,
    this.initialGradient,
  });

  final PlayerViewModel viewModel;
  final LinearGradient? initialGradient;

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late LinearGradient _gradient;
  String? _gradientArtPath;
  int _gradientGeneration = 0;

  @override
  void initState() {
    super.initState();
    _gradient = widget.initialGradient ??
        (widget.viewModel.currentTrack?.artCachePath == null
            ? _fallbackGradient(widget.viewModel.currentTrack)
            : PlayerGradient.darkNoArt);
    widget.viewModel.addListener(_onTrackChanged);

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _syncGradientFromCache();
      _refreshGradientDeferred();
    });
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onTrackChanged);
    super.dispose();
  }

  void _onTrackChanged() {
    _syncGradientFromCache();
    _refreshGradientDeferred();
  }

  void _syncGradientFromCache() {
    final track = widget.viewModel.currentTrack;
    final artPath = track?.artCachePath;
    if (artPath == null || artPath == _gradientArtPath) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cached = ArtworkPaletteCache.instance.gradientFor(
      artPath,
      isDark: isDark,
    );
    if (cached != null) {
      _gradientArtPath = artPath;
      setState(() => _gradient = cached);
    }
  }

  Future<void> _refreshGradientDeferred() async {
    final track = widget.viewModel.currentTrack;
    final artPath = track?.artCachePath;
    if (artPath == null) {
      if (mounted) {
        setState(() {
          _gradientArtPath = null;
          _gradient = _fallbackGradient(track);
        });
      }
      return;
    }
    if (artPath == _gradientArtPath &&
        ArtworkPaletteCache.instance.gradientFor(artPath, isDark: _isDark) !=
            null) {
      return;
    }

    final generation = ++_gradientGeneration;
    final isDark = _isDark;
    final gradient = await ArtworkPaletteCache.instance.warmTrack(
      track,
      isDark: isDark,
    );

    if (!mounted || generation != _gradientGeneration) return;
    if (gradient != null) {
      setState(() {
        _gradientArtPath = artPath;
        _gradient = gradient;
      });
    } else if (_gradientArtPath != artPath) {
      setState(() {
        _gradientArtPath = artPath;
        _gradient = _fallbackGradient(track);
      });
    }
  }

  LinearGradient _fallbackGradient(Track? track) {
    final seed = track?.fileUri ?? 'unknown';
    final colors = TrackArtworkPlaceholder.gradientColorsFor(seed);
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        colors.first,
        const Color(0xFF0A0A0A),
      ],
    );
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    final track = widget.viewModel.currentTrack;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(gradient: _gradient),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  color: Colors.white,
                  iconSize: 32,
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: RepaintBoundary(
                      child: _Artwork(
                        key: ValueKey(track?.fileUri),
                        track: track,
                      ),
                    ),
                  ),
                ),
              ),
              RepaintBoundary(
                child: _PlayerControlsHost(viewModel: widget.viewModel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlayerControlsHost extends StatelessWidget {
  const _PlayerControlsHost({required this.viewModel});

  final PlayerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final track = viewModel.currentTrack;

        return GlassPanel(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          blurSigma: 18,
          tintColor: Colors.black.withValues(alpha: 0.42),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            children: [
              Text(
                track?.displayTitle ?? 'Chưa phát',
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                track?.displayArtist ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 24),
              PlayerProgressSlider(
                key: ValueKey(track?.fileUri),
                position: viewModel.position,
                duration: viewModel.duration,
                onSeek: viewModel.seek,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: viewModel.cycleRepeatMode,
                    icon: Icon(_repeatIcon(viewModel.repeatMode)),
                    color: Colors.white,
                    iconSize: 28,
                  ),
                  IconButton(
                    onPressed: viewModel.skipToPrevious,
                    icon: const Icon(Icons.skip_previous),
                    color: Colors.white,
                    iconSize: 36,
                  ),
                  IconButton(
                    onPressed:
                        viewModel.isPreparing ? null : viewModel.togglePlayPause,
                    icon: Icon(
                      viewModel.playing
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                    ),
                    color: Colors.white,
                    iconSize: 64,
                  ),
                  IconButton(
                    onPressed: viewModel.skipToNext,
                    icon: const Icon(Icons.skip_next),
                    color: Colors.white,
                    iconSize: 36,
                  ),
                  TextButton(
                    onPressed: viewModel.cycleSpeed,
                    child: Text(
                      '${viewModel.speed}x',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _repeatIcon(app.RepeatMode mode) => switch (mode) {
        app.RepeatMode.off => Icons.repeat,
        app.RepeatMode.one => Icons.repeat_one,
        app.RepeatMode.all => Icons.repeat,
      };
}

class _Artwork extends StatefulWidget {
  const _Artwork({super.key, required this.track});

  final Track? track;

  @override
  State<_Artwork> createState() => _ArtworkState();
}

class _ArtworkState extends State<_Artwork> {
  ImageProvider? _imageProvider;
  int? _cacheSize;

  @override
  void initState() {
    super.initState();
    _resolveArt();
  }

  @override
  void didUpdateWidget(covariant _Artwork oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.track?.artCachePath != widget.track?.artCachePath) {
      _resolveArt();
    }
  }

  void _resolveArt() {
    final artPath = widget.track?.artCachePath;
    if (artPath != null && File(artPath).existsSync()) {
      _imageProvider = FileImage(File(artPath));
    } else {
      _imageProvider = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 0.85;
    final cacheSize =
        (width * MediaQuery.devicePixelRatioOf(context)).round();
    _cacheSize = cacheSize;

    if (_imageProvider != null) {
      final image = _cacheSize != null
          ? ResizeImage(_imageProvider!, width: _cacheSize, height: _cacheSize)
          : _imageProvider!;
      return GlassArtworkFrame(
        borderRadius: 12,
        child: Image(
          image: image,
          width: width,
          height: width,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          filterQuality: FilterQuality.medium,
        ),
      );
    }

    return TrackArtworkPlaceholder(
      seed: widget.track?.fileUri ?? 'unknown',
      label: widget.track?.displayTitle,
      size: width,
      borderRadius: 12,
      playing: false,
    );
  }
}

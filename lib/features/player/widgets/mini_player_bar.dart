import 'package:flutter/material.dart';

import '../../../core/widgets/animated_play_pause_button.dart';
import '../../../core/widgets/glass_panel.dart';
import '../../../core/widgets/track_artwork.dart';
import '../../../domain/models/track.dart';
import 'mini_player_seek_bar.dart';

/// Mini player — viền trên = thanh tiến trình (một khối).
class MiniPlayerBar extends StatelessWidget {
  const MiniPlayerBar({
    super.key,
    required this.track,
    required this.playing,
    required this.isPreparing,
    required this.position,
    required this.duration,
    this.onTap,
    this.onPlayPause,
    this.onSeek,
  });

  final Track? track;
  final bool playing;
  final bool isPreparing;
  final Duration position;
  final Duration duration;
  final VoidCallback? onTap;
  final VoidCallback? onPlayPause;
  final ValueChanged<Duration>? onSeek;

  static const _contentHeight = 64.0;

  @override
  Widget build(BuildContext context) {
    if (track == null) return const SizedBox.shrink();

    return GlassPanel(
      blurSigma: 10,
      useBlur: false,
      clip: false,
      showTopBorder: false,
      borderColor: Colors.transparent,
      tintColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black.withValues(alpha: 0.38)
          : Colors.white.withValues(alpha: 0.58),
      child: SizedBox(
        height: _contentHeight + MiniPlayerSeekBar.borderHeight,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: MiniPlayerSeekBar.borderHeight,
              left: 0,
              right: 0,
              height: _contentHeight,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      TrackArtwork(
                        trackSeed: track!.fileUri,
                        artCachePath: track!.artCachePath,
                        displayTitle: track!.displayTitle,
                        playing: playing,
                        size: 48,
                        borderRadius: TrackArtworkRadius.mini,
                        cacheSize: 96,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                track!.displayTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              if (track!.displayArtist.isNotEmpty)
                                Text(
                                  track!.displayArtist,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (isPreparing)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      else
                        AnimatedPlayPauseButton(
                          playing: playing,
                          iconSize: 32,
                          onPressed: onPlayPause,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: MiniPlayerSeekBar(
                position: position,
                duration: duration,
                onSeek: onSeek ?? (_) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/widgets/glass_panel.dart';
import '../../../core/widgets/track_artwork.dart';
import '../../../domain/models/track.dart';

/// Mini player — xem [mini_player_bar.md].
class MiniPlayerBar extends StatelessWidget {
  const MiniPlayerBar({
    super.key,
    required this.track,
    required this.playing,
    required this.isPreparing,
    this.onTap,
    this.onPlayPause,
  });

  final Track? track;
  final bool playing;
  final bool isPreparing;
  final VoidCallback? onTap;
  final VoidCallback? onPlayPause;

  @override
  Widget build(BuildContext context) {
    if (track == null) return const SizedBox.shrink();

    return GlassPanel(
      blurSigma: 10,
      tintColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.black.withValues(alpha: 0.38)
          : Colors.white.withValues(alpha: 0.58),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 64,
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
                  IconButton(
                    onPressed: onPlayPause,
                    icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                    iconSize: 32,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

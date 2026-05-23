import 'package:flutter/material.dart';

/// Mini player — xem [mini_player_bar.md].
class MiniPlayerBar extends StatelessWidget {
  const MiniPlayerBar({super.key, this.onTap, this.onPlayPause});

  final VoidCallback? onTap;
  final VoidCallback? onPlayPause;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              const SizedBox(width: 12),
              const Icon(Icons.music_note),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Chưa phát'),
                ),
              ),
              IconButton(
                onPressed: onPlayPause,
                icon: const Icon(Icons.play_arrow),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

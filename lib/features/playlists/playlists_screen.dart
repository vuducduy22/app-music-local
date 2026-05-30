import 'package:flutter/material.dart';

/// Danh sách playlist — xem [playlists.md].
class PlaylistsScreen extends StatelessWidget {
  const PlaylistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Playlist'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
            tooltip: 'Tạo playlist',
          ),
        ],
      ),
      body: const Center(child: Text('Playlist — TODO M3')),
    );
  }
}

import 'package:flutter/material.dart';

import '../library/library_screen.dart';

/// Khung app — xem [shell.md].
class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const LibraryScreen(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (_) {},
        destinations: const [
          NavigationDestination(icon: Icon(Icons.library_music), label: 'Thư viện'),
          NavigationDestination(icon: Icon(Icons.queue_music), label: 'Playlist'),
          NavigationDestination(icon: Icon(Icons.history), label: 'Lịch sử'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Cài đặt'),
        ],
      ),
    );
  }
}

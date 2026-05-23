import 'package:flutter/material.dart';

/// Màn phát đầy đủ — xem [player.md].
class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đang phát')),
      body: const Center(child: Text('Player — TODO M2')),
    );
  }
}

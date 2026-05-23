import 'package:flutter/material.dart';

/// Yêu thích — xem [favorites.md].
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yêu thích')),
      body: const Center(child: Text('Favorites — TODO M3')),
    );
  }
}

import 'package:flutter/material.dart';

/// Lịch sử nghe — xem [history.md].
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch sử')),
      body: const Center(child: Text('History — TODO M3')),
    );
  }
}

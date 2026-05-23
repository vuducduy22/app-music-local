import 'package:flutter/material.dart';

/// Sửa tên bài thiếu tag — xem [track_edit.md].
class TrackEditScreen extends StatelessWidget {
  const TrackEditScreen({super.key, required this.trackId});

  final int trackId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Điền thông tin bài')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const TextField(decoration: InputDecoration(labelText: 'Tên bài')),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Nghệ sĩ')),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {},
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}

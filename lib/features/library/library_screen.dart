import 'package:flutter/material.dart';

/// Danh sách nhạc — xem [library.md].
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thư viện'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            tooltip: 'Tìm kiếm',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
            tooltip: 'Quét lại',
          ),
        ],
      ),
      body: const Center(child: Text('Chưa có bài — bấm Refresh sau khi chọn thư mục')),
    );
  }
}

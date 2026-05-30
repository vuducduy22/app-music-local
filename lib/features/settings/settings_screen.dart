import 'package:flutter/material.dart';

/// Cài đặt — xem [settings.md].
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Cài đặt')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('Thư mục nhạc'),
            subtitle: const Text('Chưa chọn'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Giao diện'),
            subtitle: const Text('Tối / Sáng'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Ngôn ngữ'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

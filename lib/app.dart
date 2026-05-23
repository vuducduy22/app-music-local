import 'package:flutter/material.dart';

import 'features/shell/shell_screen.dart';

/// Root [MaterialApp] — theme, locale, routes sẽ nối từ [features/settings].
class LocalMusicPlayerApp extends StatelessWidget {
  const LocalMusicPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Music Player',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ShellScreen(),
    );
  }
}

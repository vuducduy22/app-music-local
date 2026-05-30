import 'package:flutter/material.dart';

import 'app/app_startup.dart';
import 'core/theme/app_theme_data.dart';
import 'core/widgets/app_ambient_background.dart';

/// Root [MaterialApp].
class LocalMusicPlayerApp extends StatelessWidget {
  const LocalMusicPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Music Player',
      theme: buildAppDarkTheme(),
      darkTheme: buildAppDarkTheme(),
      themeMode: ThemeMode.dark,
      home: const AppAmbientBackground(
        child: AppStartup(),
      ),
    );
  }
}

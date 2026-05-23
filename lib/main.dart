import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/app_dependencies.dart';
import 'core/utils/android_permissions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestAndroidMediaPermissions();
  await AppDependencies.init();
  runApp(const LocalMusicPlayerApp());
}

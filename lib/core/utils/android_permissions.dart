import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

/// Xin quyền đọc nhạc trên Android (bổ sung cho SAF).
/// Gọi sau khi Activity sẵn sàng — [AppStartup] hoặc sau `runApp`.
Future<void> requestAndroidMediaPermissions() async {
  if (kIsWeb || !Platform.isAndroid) return;

  final audio = await Permission.audio.status;
  if (!audio.isGranted) {
    await Permission.audio.request();
  }

  final storage = await Permission.storage.status;
  if (!storage.isGranted && !storage.isPermanentlyDenied) {
    await Permission.storage.request();
  }
}

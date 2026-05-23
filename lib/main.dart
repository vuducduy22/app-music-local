import 'package:flutter/material.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO(M0): đăng ký AudioHandler (audio_service) trước runApp
  runApp(const LocalMusicPlayerApp());
}

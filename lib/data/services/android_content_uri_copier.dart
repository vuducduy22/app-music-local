import 'package:flutter/services.dart';

/// Copy `content://` sang file tạm trên Android (MethodChannel).
class AndroidContentUriCopier {
  static const _channel = MethodChannel(
    'com.example.local_music_player/content_uri',
  );

  static Future<String> copyToCache({
    required String contentUri,
    required String fileName,
  }) async {
    final path = await _channel.invokeMethod<String>('copyToCache', {
      'uri': contentUri,
      'fileName': fileName,
    });
    if (path == null || path.isEmpty) {
      throw PlatformException(
        code: 'COPY_FAILED',
        message: 'Không copy được file nhạc',
      );
    }
    return path;
  }
}

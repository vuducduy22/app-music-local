import 'dart:io';

import 'package:flutter/foundation.dart';

import 'android_content_uri_copier.dart';

/// Chuyển `content://` sang path file để [just_audio] phát trên Android.
class SafPlaybackPathResolver {
  Future<String> resolve({
    required String fileRef,
    required String fileName,
  }) async {
    if (!fileRef.startsWith('content://')) {
      return fileRef;
    }

    if (!kIsWeb && Platform.isAndroid) {
      return AndroidContentUriCopier.copyToCache(
        contentUri: fileRef,
        fileName: fileName,
      );
    }

    throw UnsupportedError(
      'Phát file content:// chỉ hỗ trợ Android trong bản hiện tại.',
    );
  }
}

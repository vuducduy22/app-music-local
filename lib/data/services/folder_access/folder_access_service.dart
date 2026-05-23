import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:saf_util/saf_util.dart';

/// Chọn thư mục nhạc (SAF trên Android) — xem [folder_access.md].
abstract class FolderAccessService {
  Future<String?> pickMusicFolder();
  Future<bool> hasValidFolderAccess(String folderRef);
}

class FolderAccessServiceImpl implements FolderAccessService {
  FolderAccessServiceImpl() : _saf = SafUtil();

  final SafUtil _saf;

  @override
  Future<String?> pickMusicFolder() async {
    if (!kIsWeb && Platform.isAndroid) {
      final dir = await _saf.pickDirectory(persistablePermission: true);
      return dir?.uri;
    }

    final path = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Chọn thư mục nhạc',
    );
    if (path == null || path.isEmpty) return null;
    return path;
  }

  @override
  Future<bool> hasValidFolderAccess(String folderRef) async {
    if (folderRef.isEmpty) return false;
    if (folderRef.startsWith('content://')) {
      return _saf.exists(folderRef, true);
    }
    return Directory(folderRef).exists();
  }
}

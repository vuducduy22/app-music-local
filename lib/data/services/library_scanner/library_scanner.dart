import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:saf_util/saf_util.dart';

import '../../../core/constants/app_constants.dart';
import '../../models/scanned_audio_file.dart';

/// Quét thư mục nhạc đệ quy — xem [library_scanner.md].
abstract class LibraryScanner {
  /// [folderRef] — đường dẫn file hoặc `content://` (SAF) trên Android.
  Future<List<ScannedAudioFile>> scan(String folderRef);
}

class LibraryScannerImpl implements LibraryScanner {
  LibraryScannerImpl() : _saf = SafUtil();

  final SafUtil _saf;

  @override
  Future<List<ScannedAudioFile>> scan(String folderRef) async {
    final files = folderRef.startsWith('content://')
        ? await _scanSafTree(folderRef)
        : await _scanFileSystem(folderRef);

    files.sort(
      (a, b) => a.fileName.toLowerCase().compareTo(b.fileName.toLowerCase()),
    );
    return files;
  }

  Future<List<ScannedAudioFile>> _scanFileSystem(String folderPath) async {
    final dir = Directory(folderPath);
    if (!await dir.exists()) {
      throw StateError('Thư mục không tồn tại: $folderPath');
    }

    final files = <ScannedAudioFile>[];
    await for (final entity in dir.list(
      recursive: true,
      followLinks: false,
    )) {
      if (entity is! File) continue;
      final file = _fromPath(entity.path);
      if (file != null) files.add(file);
    }
    return files;
  }

  Future<List<ScannedAudioFile>> _scanSafTree(String treeUri) async {
    if (!await _saf.exists(treeUri, true)) {
      throw StateError('Không có quyền đọc thư mục. Hãy chọn lại thư mục.');
    }

    final files = <ScannedAudioFile>[];
    await _walkSafDirectory(treeUri, files);
    return files;
  }

  Future<void> _walkSafDirectory(
    String uri,
    List<ScannedAudioFile> out,
  ) async {
    final entries = await _saf.list(uri);
    for (final entry in entries) {
      if (entry.isDir) {
        await _walkSafDirectory(entry.uri, out);
      } else {
        final file = _fromNameAndUri(entry.name, entry.uri);
        if (file != null) out.add(file);
      }
    }
  }

  ScannedAudioFile? _fromPath(String path) {
    final ext = p.extension(path).toLowerCase();
    if (!AppConstants.supportedAudioExtensions.contains(ext)) return null;
    return ScannedAudioFile(path: path, fileName: p.basename(path));
  }

  ScannedAudioFile? _fromNameAndUri(String name, String uri) {
    final ext = p.extension(name).toLowerCase();
    if (!AppConstants.supportedAudioExtensions.contains(ext)) return null;
    return ScannedAudioFile(path: uri, fileName: name);
  }
}

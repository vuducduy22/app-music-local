import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../saf_playback_path_resolver.dart';
import 'track_metadata_result.dart';

/// Đọc ID3 / metadata — xem [metadata.md].
abstract class MetadataService {
  Future<TrackMetadataResult> readFromFileRef({
    required String fileRef,
    required String fileName,
  });

  Future<String?> saveArtCache({
    required String fileUri,
    required List<int> bytes,
  });
}

class MetadataServiceImpl implements MetadataService {
  MetadataServiceImpl({SafPlaybackPathResolver? pathResolver})
      : _pathResolver = pathResolver ?? SafPlaybackPathResolver();

  final SafPlaybackPathResolver _pathResolver;

  @override
  Future<TrackMetadataResult> readFromFileRef({
    required String fileRef,
    required String fileName,
  }) async {
    try {
      final path = await _pathResolver.resolve(
        fileRef: fileRef,
        fileName: fileName,
      );
      final file = File(path);
      if (!await file.exists()) {
        return const TrackMetadataResult(missingTags: true);
      }

      final metadata = readMetadata(file, getImage: true);
      final title = _clean(metadata.title);
      final artist = _clean(metadata.artist);
      final album = _clean(metadata.album);
      final durationMs = metadata.duration?.inMilliseconds;
      final art = metadata.pictures.isNotEmpty
          ? metadata.pictures.first.bytes
          : null;

      final missingTags = (title == null || title.isEmpty) &&
          (artist == null || artist.isEmpty);

      return TrackMetadataResult(
        title: title,
        artist: artist,
        album: album,
        durationMs: durationMs != null && durationMs > 0 ? durationMs : null,
        albumArtBytes: art,
        missingTags: missingTags,
      );
    } catch (e, st) {
      debugPrint('MetadataService.readFromFileRef: $e\n$st');
      return const TrackMetadataResult(missingTags: true);
    }
  }

  @override
  Future<String?> saveArtCache({
    required String fileUri,
    required List<int> bytes,
  }) async {
    if (bytes.isEmpty) return null;

    final dir = await getApplicationDocumentsDirectory();
    final cacheDir = Directory(p.join(dir.path, 'art_cache'));
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }

    final safeName = fileUri.hashCode.abs().toRadixString(16);
    final file = File(p.join(cacheDir.path, '$safeName.jpg'));
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  String? _clean(String? value) {
    if (value == null) return null;
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}

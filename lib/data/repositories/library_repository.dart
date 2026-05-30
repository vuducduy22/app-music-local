import '../../domain/enums/sort_option.dart';
import '../../domain/models/track.dart';
import '../local/daos/track_dao.dart';
import '../models/scanned_audio_file.dart';
import '../models/track_entity.dart';
import '../services/library_scanner/library_scanner.dart';
import '../services/metadata/metadata_service.dart';
import 'settings_repository.dart';

/// Thư viện nhạc — xem [repositories.md].
abstract class LibraryRepository {
  Future<List<Track>> getTracks({
    String? query,
    SortOption sort = SortOption.fileName,
  });

  Future<void> refreshLibrary();

  Future<Track?> getTrackById(int id);
  Future<Track?> findTrackByUri(String fileUri);

  Future<void> updateCustomMetadata({
    required int trackId,
    required String? customTitle,
    required String? customArtist,
  });
}

class LibraryRepositoryImpl implements LibraryRepository {
  LibraryRepositoryImpl(
    this._settings,
    this._scanner,
    this._trackDao,
    this._metadata,
  );

  final SettingsRepository _settings;
  final LibraryScanner _scanner;
  final TrackDao _trackDao;
  final MetadataService _metadata;

  @override
  Future<List<Track>> getTracks({
    String? query,
    SortOption sort = SortOption.fileName,
  }) async {
    final rows = await _trackDao.getAll(query: query, sort: sort);
    return rows.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Track?> getTrackById(int id) async {
    final entity = await _trackDao.findById(id);
    return entity?.toDomain();
  }

  @override
  Future<Track?> findTrackByUri(String fileUri) async {
    final entity = await _trackDao.findByUri(fileUri);
    return entity?.toDomain();
  }

  @override
  Future<void> refreshLibrary() async {
    final folder = await _settings.getMusicFolderPath();
    if (folder == null) {
      await _trackDao.deleteAll();
      return;
    }

    final scanned = await _scanner.scan(folder);
    final batchNow = DateTime.now().millisecondsSinceEpoch;

    for (final file in scanned) {
      await _upsertScannedFile(file, batchNow);
    }

    await _trackDao.deleteWhereLastSeenBefore(batchNow);
  }

  Future<void> _upsertScannedFile(ScannedAudioFile file, int batchNow) async {
    final existing = await _trackDao.findByUri(file.path);
    final modifiedMs = file.modifiedAtMs ?? batchNow;

    if (existing == null) {
      await _insertFromScan(file, batchNow, modifiedMs);
      return;
    }

    if (file.modifiedAtMs != null &&
        existing.fileModifiedAtMs != file.modifiedAtMs) {
      await _updateMetadataFromScan(existing, file, batchNow, modifiedMs);
      return;
    }

    await _trackDao.update(
      existing.copyWith(lastSeenAtMs: batchNow),
    );
  }

  Future<void> _insertFromScan(
    ScannedAudioFile file,
    int batchNow,
    int modifiedMs,
  ) async {
    final meta = await _metadata.readFromFileRef(
      fileRef: file.path,
      fileName: file.fileName,
    );
    final artPath = meta.albumArtBytes != null
        ? await _metadata.saveArtCache(
            fileUri: file.path,
            bytes: meta.albumArtBytes!,
          )
        : null;

    await _trackDao.insert(
      TrackEntity(
        id: 0,
        fileUri: file.path,
        fileName: file.fileName,
        title: meta.title,
        artist: meta.artist,
        album: meta.album,
        durationMs: meta.durationMs,
        artCachePath: artPath,
        missingTags: meta.missingTags,
        fileModifiedAtMs: modifiedMs,
        lastSeenAtMs: batchNow,
        createdAtMs: batchNow,
      ),
    );
  }

  Future<void> _updateMetadataFromScan(
    TrackEntity existing,
    ScannedAudioFile file,
    int batchNow,
    int modifiedMs,
  ) async {
    final meta = await _metadata.readFromFileRef(
      fileRef: file.path,
      fileName: file.fileName,
    );
    final artPath = meta.albumArtBytes != null
        ? await _metadata.saveArtCache(
            fileUri: file.path,
            bytes: meta.albumArtBytes!,
          )
        : existing.artCachePath;

    await _trackDao.update(
      existing.copyWith(
        fileName: file.fileName,
        title: meta.title,
        artist: meta.artist,
        album: meta.album,
        durationMs: meta.durationMs,
        artCachePath: artPath,
        missingTags: meta.missingTags && existing.customTitle == null,
        fileModifiedAtMs: modifiedMs,
        lastSeenAtMs: batchNow,
      ),
    );
  }

  @override
  Future<void> updateCustomMetadata({
    required int trackId,
    required String? customTitle,
    required String? customArtist,
  }) async {
    final title = customTitle?.trim();
    final artist = customArtist?.trim();
    final hasTitle = title != null && title.isNotEmpty;
    await _trackDao.updateCustomFields(
      trackId: trackId,
      customTitle: hasTitle ? title : null,
      customArtist: artist != null && artist.isNotEmpty ? artist : null,
      missingTags: !hasTitle,
    );
  }
}

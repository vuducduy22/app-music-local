import 'package:flutter_test/flutter_test.dart';
import 'package:local_music_player/data/local/app_database.dart';
import 'package:local_music_player/data/local/daos/track_dao.dart';
import 'package:local_music_player/data/models/scanned_audio_file.dart';
import 'package:local_music_player/data/repositories/library_repository.dart';
import 'package:local_music_player/data/repositories/settings_repository.dart';
import 'package:local_music_player/data/services/folder_access/folder_access_service.dart';
import 'package:local_music_player/data/services/library_scanner/library_scanner.dart';
import 'package:local_music_player/data/services/metadata/metadata_service.dart';
import 'package:local_music_player/data/services/metadata/track_metadata_result.dart';
import 'package:local_music_player/domain/enums/sort_option.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('LibraryRepository M1', () {
    late SettingsRepository settings;
    late _FakeScanner scanner;
    late AppDatabase database;
    late TrackDao trackDao;
    late LibraryRepositoryImpl library;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      settings = SettingsRepositoryImpl(prefs, _FakeFolderAccess());
      scanner = _FakeScanner();
      database = AppDatabase();
      trackDao = TrackDao(database);
      library = LibraryRepositoryImpl(
        settings,
        scanner,
        trackDao,
        _FakeMetadata(),
      );
    });

    tearDown(() async {
      await database.close();
    });

    test('refresh loads tracks into SQLite with metadata', () async {
      await settings.setMusicFolderPath('/music');
      scanner.files = [
        ScannedAudioFile(
          path: '/music/a.mp3',
          fileName: 'a.mp3',
          modifiedAtMs: 1000,
        ),
      ];

      await library.refreshLibrary();
      final tracks = await library.getTracks(sort: SortOption.title);

      expect(tracks, hasLength(1));
      expect(tracks.first.fileName, 'a.mp3');
      expect(tracks.first.title, 'Test Song');
      expect(tracks.first.artist, 'Test Artist');
    });

    test('search filters by title', () async {
      await settings.setMusicFolderPath('/music');
      scanner.files = [
        ScannedAudioFile(
          path: '/music/a.mp3',
          fileName: 'a.mp3',
          modifiedAtMs: 1000,
        ),
        ScannedAudioFile(
          path: '/music/b.mp3',
          fileName: 'b.mp3',
          modifiedAtMs: 1000,
        ),
      ];

      await library.refreshLibrary();
      final tracks = await library.getTracks(query: 'artist');

      expect(tracks, hasLength(2));
    });
  });
}

class _FakeFolderAccess implements FolderAccessService {
  @override
  Future<bool> hasValidFolderAccess(String folderRef) async => true;

  @override
  Future<String?> pickMusicFolder() async => null;
}

class _FakeScanner implements LibraryScanner {
  List<ScannedAudioFile> files = [];

  @override
  Future<List<ScannedAudioFile>> scan(String folderPath) async => files;
}

class _FakeMetadata implements MetadataService {
  @override
  Future<TrackMetadataResult> readFromFileRef({
    required String fileRef,
    required String fileName,
  }) async {
    return TrackMetadataResult(
      title: 'Test Song',
      artist: 'Test Artist',
      durationMs: 180000,
      missingTags: false,
    );
  }

  @override
  Future<String?> saveArtCache({
    required String fileUri,
    required List<int> bytes,
  }) async =>
      null;
}

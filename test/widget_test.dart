import 'package:flutter_test/flutter_test.dart';
import 'package:local_music_player/data/models/scanned_audio_file.dart';
import 'package:local_music_player/data/repositories/library_repository.dart';
import 'package:local_music_player/data/repositories/settings_repository.dart';
import 'package:local_music_player/data/services/folder_access/folder_access_service.dart';
import 'package:local_music_player/data/services/library_scanner/library_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LibraryRepository M0', () {
    late SettingsRepository settings;
    late _FakeScanner scanner;
    late LibraryRepositoryImpl library;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      settings = SettingsRepositoryImpl(prefs, _FakeFolderAccess());
      scanner = _FakeScanner();
      library = LibraryRepositoryImpl(settings, scanner);
    });

    test('refresh loads scanned files', () async {
      await settings.setMusicFolderPath('/music');
      scanner.files = [
        const ScannedAudioFile(path: '/music/a.mp3', fileName: 'a.mp3'),
      ];

      await library.refreshLibrary();
      final tracks = await library.getTracks();

      expect(tracks, hasLength(1));
      expect(tracks.first.fileName, 'a.mp3');
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

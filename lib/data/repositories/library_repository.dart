import '../models/scanned_audio_file.dart';
import '../services/library_scanner/library_scanner.dart';
import 'settings_repository.dart';

/// Thư viện nhạc — xem [repositories.md].
abstract class LibraryRepository {
  Future<List<ScannedAudioFile>> getTracks();
  Future<void> refreshLibrary();
}

class LibraryRepositoryImpl implements LibraryRepository {
  LibraryRepositoryImpl(this._settings, this._scanner);

  final SettingsRepository _settings;
  final LibraryScanner _scanner;

  List<ScannedAudioFile> _cache = [];

  @override
  Future<List<ScannedAudioFile>> getTracks() async {
    return List.unmodifiable(_cache);
  }

  @override
  Future<void> refreshLibrary() async {
    final path = await _settings.getMusicFolderPath();
    if (path == null) {
      _cache = [];
      return;
    }
    _cache = await _scanner.scan(path);
  }
}

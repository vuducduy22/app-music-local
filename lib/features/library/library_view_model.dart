import 'dart:async';

import 'package:flutter/foundation.dart' show ChangeNotifier, debugPrint;

import '../../audio/audio_controller.dart';
import '../../data/models/scanned_audio_file.dart';
import '../../data/repositories/library_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/services/folder_access/folder_access_service.dart';

/// Logic thư viện — xem [library.md].
class LibraryViewModel extends ChangeNotifier {
  LibraryViewModel({
    required LibraryRepository libraryRepository,
    required AudioController audioController,
    required SettingsRepository settingsRepository,
    required FolderAccessService folderAccessService,
  })  : _library = libraryRepository,
        _audio = audioController,
        _settings = settingsRepository,
        _folderAccess = folderAccessService {
    _playingSub = _audio.playingStream.listen((playing) {
      _isPlaying = playing;
      notifyListeners();
    });
  }

  final LibraryRepository _library;
  final AudioController _audio;
  final SettingsRepository _settings;
  final FolderAccessService _folderAccess;
  late final StreamSubscription<bool> _playingSub;

  List<ScannedAudioFile> _tracks = [];
  bool _isRefreshing = false;
  bool _isLoading = false;
  bool _isPlaying = false;
  String? _error;

  List<ScannedAudioFile> get tracks => _tracks;
  bool get isRefreshing => _isRefreshing;
  bool get isLoading => _isLoading;
  bool get isPreparingPlayback => _audio.isPreparing;
  String? get error => _error;
  String? get playingPath => _audio.currentPath;

  bool isPlaying(ScannedAudioFile file) =>
      _audio.currentPath == file.path && _isPlaying;

  @override
  void dispose() {
    unawaited(_playingSub.cancel());
    super.dispose();
  }

  Future<void> loadTracks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _tracks = await _library.getTracks();
      if (_tracks.isEmpty) {
        await refresh();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    _isRefreshing = true;
    _error = null;
    notifyListeners();
    try {
      await _library.refreshLibrary();
      _tracks = await _library.getTracks();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<String?> getMusicFolderPath() => _settings.getMusicFolderPath();

  /// Chọn thư mục khác và quét lại.
  Future<bool> changeMusicFolder() async {
    try {
      final path = await _folderAccess.pickMusicFolder();
      if (path == null) return false;

      final valid = await _folderAccess.hasValidFolderAccess(path);
      if (!valid) {
        _error = 'Không đọc được thư mục đã chọn.';
        notifyListeners();
        return false;
      }

      await _settings.setMusicFolderPath(path);
      await refresh();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> togglePlay(ScannedAudioFile file) async {
    _error = null;
    notifyListeners();
    try {
      if (_audio.currentPath == file.path && _isPlaying) {
        await _audio.pause();
        return true;
      }
      await _audio.playFile(file.path, fileName: file.fileName);
      return true;
    } catch (e, st) {
      _error = 'Không phát được nhạc.\n$e';
      debugPrint('togglePlay error: $e\n$st');
      notifyListeners();
      return false;
    }
  }
}

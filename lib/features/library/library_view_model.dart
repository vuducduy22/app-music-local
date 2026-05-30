import 'dart:async';

import 'package:flutter/foundation.dart' show ChangeNotifier, debugPrint;

import '../../audio/audio_controller.dart';
import '../../data/repositories/library_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/services/folder_access/folder_access_service.dart';
import '../../domain/enums/sort_option.dart';
import '../../domain/models/track.dart';

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
    _audio.addListener(_onAudioChanged);
  }

  final LibraryRepository _library;
  final AudioController _audio;
  final SettingsRepository _settings;
  final FolderAccessService _folderAccess;
  late final StreamSubscription<bool> _playingSub;

  List<Track> _tracks = [];
  bool _isRefreshing = false;
  bool _isLoading = false;
  bool _isPlaying = false;
  String? _error;
  String _query = '';
  SortOption _sort = SortOption.fileName;

  List<Track> get tracks => _tracks;
  bool get isRefreshing => _isRefreshing;
  bool get isLoading => _isLoading;
  bool get isPreparingPlayback => _audio.isPreparing;
  String? get error => _error;
  String? get playingPath => _audio.currentPath;
  String get query => _query;
  SortOption get sort => _sort;

  bool isPlaying(Track track) =>
      _audio.currentPath == track.fileUri && _isPlaying;

  void _onAudioChanged() {
    _isPlaying = _audio.playbackState.playing;
    notifyListeners();
  }

  @override
  void dispose() {
    _audio.removeListener(_onAudioChanged);
    unawaited(_playingSub.cancel());
    super.dispose();
  }

  Future<void> loadTracks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _tracks = await _library.getTracks(query: _query, sort: _sort);
      if (_tracks.isEmpty && _query.isEmpty) {
        final hasFolder = await _settings.hasMusicFolder();
        if (hasFolder) {
          await refresh();
        }
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
      _tracks = await _library.getTracks(query: _query, sort: _sort);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  void setQuery(String value) {
    _query = value;
    unawaited(_reloadFromDb());
  }

  void setSort(SortOption value) {
    _sort = value;
    unawaited(_reloadFromDb());
  }

  Future<void> _reloadFromDb() async {
    try {
      _tracks = await _library.getTracks(query: _query, sort: _sort);
      _error = null;
    } catch (e) {
      _error = e.toString();
    }
    notifyListeners();
  }

  Future<String?> getMusicFolderPath() => _settings.getMusicFolderPath();

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

  Future<bool> togglePlay(Track track) async {
    _error = null;
    notifyListeners();
    try {
      if (_audio.currentPath == track.fileUri && _isPlaying) {
        await _audio.pause();
        return true;
      }
      final index = _tracks.indexWhere((t) => t.id == track.id);
      await _audio.playTracks(
        _tracks,
        startIndex: index >= 0 ? index : 0,
      );
      return true;
    } catch (e, st) {
      _error = 'Không phát được nhạc.\n$e';
      debugPrint('togglePlay error: $e\n$st');
      notifyListeners();
      return false;
    }
  }

  Future<bool> saveCustomMetadata({
    required Track track,
    required String title,
    String? artist,
  }) async {
    try {
      await _library.updateCustomMetadata(
        trackId: track.id,
        customTitle: title,
        customArtist: artist,
      );
      await _reloadFromDb();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}

import 'package:flutter/foundation.dart';

import '../../domain/models/track.dart';

/// Logic thư viện — xem [library.md].
class LibraryViewModel extends ChangeNotifier {
  List<Track> _tracks = [];
  bool _isRefreshing = false;
  String? _error;

  List<Track> get tracks => _tracks;
  bool get isRefreshing => _isRefreshing;
  String? get error => _error;

  Future<void> loadTracks() async {
    // TODO(M0): LibraryRepository.getTracks()
    notifyListeners();
  }

  Future<void> refresh() async {
    _isRefreshing = true;
    _error = null;
    notifyListeners();
    try {
      // TODO(M0): LibraryRepository.refreshLibrary()
      await loadTracks();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }
}

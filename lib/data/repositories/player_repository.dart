import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/prefs_keys.dart';
import '../../domain/models/playback_snapshot.dart';

/// Lưu resume phát nhạc — xem [repositories.md].
abstract class PlayerRepository {
  Future<void> saveResume(PlaybackSnapshot snapshot);
  Future<PlaybackSnapshot?> loadResume();
  Future<void> clearResume();
}

class PlayerRepositoryImpl implements PlayerRepository {
  PlayerRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  Future<void> saveResume(PlaybackSnapshot snapshot) async {
    await _prefs.setString(
      PrefsKeys.playbackResume,
      jsonEncode({
        'fileUri': snapshot.fileUri,
        'positionMs': snapshot.positionMs,
      }),
    );
  }

  @override
  Future<PlaybackSnapshot?> loadResume() async {
    final raw = _prefs.getString(PrefsKeys.playbackResume);
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final fileUri = map['fileUri'] as String?;
      final positionMs = map['positionMs'] as int?;
      if (fileUri == null || fileUri.isEmpty || positionMs == null) return null;
      return PlaybackSnapshot(fileUri: fileUri, positionMs: positionMs);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearResume() async {
    await _prefs.remove(PrefsKeys.playbackResume);
  }
}

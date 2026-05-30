import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/prefs_keys.dart';
import '../services/folder_access/folder_access_service.dart';

/// Cài đặt app — lưu path hoặc SAF `content://` URI.
abstract class SettingsRepository {
  Future<String?> getMusicFolderPath();
  Future<void> setMusicFolderPath(String folderRef);
  Future<void> clearMusicFolderPath();
  Future<bool> hasMusicFolder();
  Future<void> requestLibraryRefreshHint();
  Future<bool> consumeLibraryRefreshHint();
}

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._prefs, this._folderAccess);

  final SharedPreferences _prefs;
  final FolderAccessService _folderAccess;

  @override
  Future<String?> getMusicFolderPath() async {
    return _prefs.getString(PrefsKeys.musicFolderPath);
  }

  @override
  Future<void> setMusicFolderPath(String folderRef) async {
    await _prefs.setString(PrefsKeys.musicFolderPath, folderRef);
  }

  @override
  Future<void> clearMusicFolderPath() async {
    await _prefs.remove(PrefsKeys.musicFolderPath);
  }

  @override
  Future<bool> hasMusicFolder() async {
    final ref = await getMusicFolderPath();
    if (ref == null || ref.isEmpty) return false;
    return _folderAccess.hasValidFolderAccess(ref);
  }

  @override
  Future<void> requestLibraryRefreshHint() async {
    await _prefs.setBool(PrefsKeys.libraryRefreshHintPending, true);
  }

  @override
  Future<bool> consumeLibraryRefreshHint() async {
    final pending = _prefs.getBool(PrefsKeys.libraryRefreshHintPending) ?? false;
    if (pending) {
      await _prefs.remove(PrefsKeys.libraryRefreshHintPending);
    }
    return pending;
  }
}

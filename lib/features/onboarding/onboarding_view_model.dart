import 'package:flutter/foundation.dart';

import '../../data/repositories/settings_repository.dart';
import '../../data/services/folder_access/folder_access_service.dart';

/// Logic onboarding — xem [onboarding.md].
class OnboardingViewModel extends ChangeNotifier {
  OnboardingViewModel({
    required FolderAccessService folderAccess,
    required SettingsRepository settings,
  })  : _folderAccess = folderAccess,
        _settings = settings;

  final FolderAccessService _folderAccess;
  final SettingsRepository _settings;

  bool _loading = false;
  String? _error;

  bool get loading => _loading;
  String? get error => _error;

  Future<bool> pickMusicFolder() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final path = await _folderAccess.pickMusicFolder();
      if (path == null) {
        return false;
      }

      final valid = await _folderAccess.hasValidFolderAccess(path);
      if (!valid) {
        _error = 'Không đọc được thư mục đã chọn.';
        return false;
      }

      await _settings.setMusicFolderPath(path);
      await _settings.requestLibraryRefreshHint();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

import 'package:flutter/foundation.dart';

/// Logic onboarding — xem [onboarding.md].
class OnboardingViewModel extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  Future<void> pickMusicFolder() async {
    _loading = true;
    notifyListeners();
    // TODO(M0): FolderAccessService + SettingsRepository
    _loading = false;
    notifyListeners();
  }
}

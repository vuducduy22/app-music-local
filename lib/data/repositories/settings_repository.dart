/// Cài đặt app — xem [repositories.md].
abstract class SettingsRepository {
  Future<String?> getMusicFolderUri();
  Future<void> setMusicFolderUri(String uri);
  Future<bool> isOnboardingComplete();
}

class SettingsRepositoryImpl implements SettingsRepository {
  @override
  Future<String?> getMusicFolderUri() async => null;

  @override
  Future<void> setMusicFolderUri(String uri) async {}

  @override
  Future<bool> isOnboardingComplete() async => false;
}

import 'package:shared_preferences/shared_preferences.dart';

import '../../audio/audio_controller.dart';
import '../../data/repositories/library_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/services/folder_access/folder_access_service.dart';
import '../../data/services/library_scanner/library_scanner.dart';

/// Container dependency M0 — xem [di.md].
class AppDependencies {
  AppDependencies._({
    required this.settingsRepository,
    required this.folderAccessService,
    required this.libraryRepository,
    required this.audioController,
  });

  final SettingsRepository settingsRepository;
  final FolderAccessService folderAccessService;
  final LibraryRepository libraryRepository;
  final AudioController audioController;

  static AppDependencies? _instance;

  static AppDependencies get instance {
    final deps = _instance;
    if (deps == null) {
      throw StateError('Gọi AppDependencies.init() trước runApp');
    }
    return deps;
  }

  static Future<AppDependencies> init() async {
    if (_instance != null) return _instance!;

    final prefs = await SharedPreferences.getInstance();
    final folderAccess = FolderAccessServiceImpl();
    final settings = SettingsRepositoryImpl(prefs, folderAccess);
    final scanner = LibraryScannerImpl();
    final library = LibraryRepositoryImpl(settings, scanner);
    final audio = AudioControllerImpl();
    await audio.init();

    _instance = AppDependencies._(
      settingsRepository: settings,
      folderAccessService: folderAccess,
      libraryRepository: library,
      audioController: audio,
    );
    return _instance!;
  }
}

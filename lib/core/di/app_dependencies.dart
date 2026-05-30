import '../../audio/audio_handler.dart';
import '../../data/local/app_database.dart';
import '../../data/local/daos/track_dao.dart';
import '../../data/repositories/library_repository.dart';
import '../../data/repositories/player_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/services/folder_access/folder_access_service.dart';
import '../../data/services/library_scanner/library_scanner.dart';
import '../../data/services/metadata/metadata_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../audio/audio_controller.dart';

/// Container dependency — xem [di.md].
class AppDependencies {
  AppDependencies._({
    required this.settingsRepository,
    required this.folderAccessService,
    required this.libraryRepository,
    required this.playerRepository,
    required this.audioController,
    required this.appDatabase,
  });

  final SettingsRepository settingsRepository;
  final FolderAccessService folderAccessService;
  final LibraryRepository libraryRepository;
  final PlayerRepository playerRepository;
  final AudioController audioController;
  final AppDatabase appDatabase;

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
    final database = AppDatabase();
    final trackDao = TrackDao(database);
    final metadata = MetadataServiceImpl();
    final library = LibraryRepositoryImpl(
      settings,
      scanner,
      trackDao,
      metadata,
    );
    final playerRepo = PlayerRepositoryImpl(prefs);

    final handler = await initAudioService(
      playerRepository: playerRepo,
      trackLookup: library.findTrackByUri,
    );
    final audio = AudioControllerImpl(handler);

    _instance = AppDependencies._(
      settingsRepository: settings,
      folderAccessService: folderAccess,
      libraryRepository: library,
      playerRepository: playerRepo,
      audioController: audio,
      appDatabase: database,
    );
    return _instance!;
  }
}

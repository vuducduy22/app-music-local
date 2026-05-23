import 'package:flutter/material.dart';

import '../core/di/app_dependencies.dart';
import '../data/repositories/settings_repository.dart';
import '../features/library/library_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/onboarding/onboarding_view_model.dart';

/// Điều hướng: chưa có folder → onboarding, ngược lại → library.
class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  late final SettingsRepository _settings;
  late final Future<bool> _hasFolderFuture;
  bool _showLibrary = false;

  @override
  void initState() {
    super.initState();
    final deps = AppDependencies.instance;
    _settings = deps.settingsRepository;
    _hasFolderFuture = _settings.hasMusicFolder();
  }

  void _onOnboardingComplete() {
    setState(() => _showLibrary = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_showLibrary) {
      return const LibraryScreen();
    }

    return FutureBuilder<bool>(
      future: _hasFolderFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return const LibraryScreen();
        }

        final deps = AppDependencies.instance;
        return OnboardingScreen(
          viewModel: OnboardingViewModel(
            folderAccess: deps.folderAccessService,
            settings: deps.settingsRepository,
          ),
          onCompleted: _onOnboardingComplete,
        );
      },
    );
  }
}

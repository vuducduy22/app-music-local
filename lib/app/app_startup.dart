import 'package:flutter/material.dart';

import '../../core/di/app_dependencies.dart';
import '../../core/utils/android_permissions.dart';
import '../../data/repositories/settings_repository.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/onboarding/onboarding_view_model.dart';
import '../features/shell/shell_screen.dart';

/// Điều hướng: chưa có folder → onboarding, ngược lại → shell.
class AppStartup extends StatefulWidget {
  const AppStartup({super.key});

  @override
  State<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends State<AppStartup> {
  late final SettingsRepository _settings;
  late final Future<bool> _hasFolderFuture;
  bool _showShell = false;

  @override
  void initState() {
    super.initState();
    final deps = AppDependencies.instance;
    _settings = deps.settingsRepository;
    _hasFolderFuture = _settings.hasMusicFolder();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestAndroidMediaPermissions().catchError((Object e) {
        debugPrint('Permission request failed: $e');
      });
    });
  }

  void _onOnboardingComplete() {
    setState(() => _showShell = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_showShell) {
      return const ShellScreen();
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
          return const ShellScreen();
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

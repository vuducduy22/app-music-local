import 'package:flutter/foundation.dart';

import '../../core/theme/app_theme.dart';

/// Logic settings — xem [settings.md].
class SettingsViewModel extends ChangeNotifier {
  AppThemeKey _theme = AppThemeKey.dark;
  AppThemeKey get theme => _theme;

  // TODO(M3): SettingsRepository
}

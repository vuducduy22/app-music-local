import 'package:flutter/foundation.dart';

import '../../domain/enums/repeat_mode.dart';

/// Logic player UI — xem [player.md].
class PlayerViewModel extends ChangeNotifier {
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  RepeatMode _repeatMode = RepeatMode.off;

  Duration get position => _position;
  Duration get duration => _duration;
  RepeatMode get repeatMode => _repeatMode;

  void cycleRepeatMode() {
    _repeatMode = switch (_repeatMode) {
      RepeatMode.off => RepeatMode.one,
      RepeatMode.one => RepeatMode.all,
      RepeatMode.all => RepeatMode.off,
    };
    notifyListeners();
    // TODO(M2): AudioController.setRepeatMode
  }
}

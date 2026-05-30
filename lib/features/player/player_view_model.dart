import 'package:flutter/foundation.dart';

import '../../audio/audio_controller.dart';
import '../../domain/enums/repeat_mode.dart';
import '../../domain/models/track.dart';

/// Logic player UI — xem [player.md].
class PlayerViewModel extends ChangeNotifier {
  PlayerViewModel(this._audio) {
    _audio.addListener(_onAudioChanged);
  }

  final AudioController _audio;

  void _onAudioChanged() => notifyListeners();

  bool get hasTrack => _audio.playbackState.hasTrack;
  bool get playing => _audio.playbackState.playing;
  bool get isPreparing => _audio.playbackState.isPreparing;
  Duration get position => _audio.playbackState.position;
  Duration get duration => _audio.playbackState.duration;
  RepeatMode get repeatMode => _audio.playbackState.repeatMode;
  double get speed => _audio.playbackState.speed;

  Track? get currentTrack => _audio.playbackState.currentTrack;

  Future<void> togglePlayPause() => _audio.togglePlayPause();
  Future<void> seek(Duration position) => _audio.seek(position);
  Future<void> skipToNext() => _audio.skipToNext();
  Future<void> skipToPrevious() => _audio.skipToPrevious();
  Future<void> cycleRepeatMode() => _audio.cycleRepeatMode();
  Future<void> cycleSpeed() => _audio.cycleSpeed();

  @override
  void dispose() {
    _audio.removeListener(_onAudioChanged);
    super.dispose();
  }
}

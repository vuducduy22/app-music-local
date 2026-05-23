import '../domain/enums/repeat_mode.dart';
import 'play_context.dart';

/// Điều khiển phát — xem [audio.md].
abstract class AudioController {
  Stream<bool> get playingStream;
  PlayContext? get playContext;

  Future<void> playTrack(PlayContext context);
  Future<void> playPause();
  Future<void> seek(Duration position);
  Future<void> skipToNext();
  Future<void> skipToPrevious();
  void setRepeatMode(RepeatMode mode);
  Future<void> setSpeed(double speed);
}

class AudioControllerImpl implements AudioController {
  @override
  Stream<bool> get playingStream => const Stream.empty();

  @override
  PlayContext? playContext;

  @override
  Future<void> playTrack(PlayContext context) async {
    playContext = context;
    // TODO(M0): just_audio setUrl
  }

  @override
  Future<void> playPause() async {}

  @override
  Future<void> seek(Duration position) async {}

  @override
  Future<void> skipToNext() async {}

  @override
  Future<void> skipToPrevious() async {}

  @override
  void setRepeatMode(RepeatMode mode) {}

  @override
  Future<void> setSpeed(double speed) async {}
}

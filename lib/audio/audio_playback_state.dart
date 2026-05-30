import '../domain/enums/repeat_mode.dart';
import '../domain/models/track.dart';
import 'play_context.dart';

/// Snapshot trạng thái phát cho UI.
class AudioPlaybackState {
  const AudioPlaybackState({
    this.currentTrack,
    this.playContext,
    this.playing = false,
    this.isPreparing = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.repeatMode = RepeatMode.off,
    this.speed = 1.0,
  });

  final Track? currentTrack;
  final PlayContext? playContext;
  final bool playing;
  final bool isPreparing;
  final Duration position;
  final Duration duration;
  final RepeatMode repeatMode;
  final double speed;

  bool get hasTrack => currentTrack != null;

  AudioPlaybackState copyWith({
    Track? currentTrack,
    PlayContext? playContext,
    bool? playing,
    bool? isPreparing,
    Duration? position,
    Duration? duration,
    RepeatMode? repeatMode,
    double? speed,
  }) {
    return AudioPlaybackState(
      currentTrack: currentTrack ?? this.currentTrack,
      playContext: playContext ?? this.playContext,
      playing: playing ?? this.playing,
      isPreparing: isPreparing ?? this.isPreparing,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      repeatMode: repeatMode ?? this.repeatMode,
      speed: speed ?? this.speed,
    );
  }
}

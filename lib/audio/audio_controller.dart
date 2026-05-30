import 'dart:async';

import 'package:flutter/foundation.dart';

import '../domain/models/track.dart';
import 'audio_handler.dart';
import 'audio_playback_state.dart';
import 'play_context.dart';

/// Facade phát nhạc cho UI — xem [audio.md].
abstract class AudioController extends ChangeNotifier {
  Stream<AudioPlaybackState> get playbackStateStream;
  AudioPlaybackState get playbackState;

  Stream<bool> get playingStream;
  String? get currentPath;
  bool get isPreparing;
  PlayContext? get playContext;

  Future<void> playTracks(List<Track> tracks, {required int startIndex});
  Future<void> togglePlayPause();
  Future<void> pause();
  Future<void> seek(Duration position);
  Future<void> skipToNext();
  Future<void> skipToPrevious();
  Future<void> cycleRepeatMode();
  Future<void> cycleSpeed();
}

class AudioControllerImpl extends AudioController {
  AudioControllerImpl(this._handler) {
    _subscription = _handler.uiStateStream.listen((state) {
      _state = state;
      notifyListeners();
    });
    _state = _handler.uiState;
  }

  final LocalMusicAudioHandler _handler;
  late final StreamSubscription<AudioPlaybackState> _subscription;
  AudioPlaybackState _state = const AudioPlaybackState();

  @override
  AudioPlaybackState get playbackState => _state;

  @override
  Stream<AudioPlaybackState> get playbackStateStream => _handler.uiStateStream;

  @override
  Stream<bool> get playingStream =>
      _handler.uiStateStream.map((s) => s.playing);

  @override
  String? get currentPath => _handler.currentFileUri;

  @override
  bool get isPreparing => _handler.isPreparing;

  @override
  PlayContext? get playContext => _state.playContext;

  @override
  Future<void> playTracks(List<Track> tracks, {required int startIndex}) =>
      _handler.playTracks(tracks, startIndex: startIndex);

  @override
  Future<void> togglePlayPause() => _handler.togglePlayPause();

  @override
  Future<void> pause() => _handler.pause();

  @override
  Future<void> seek(Duration position) => _handler.seekTo(position);

  @override
  Future<void> skipToNext() => _handler.skipToNextTrack();

  @override
  Future<void> skipToPrevious() => _handler.skipToPreviousTrack();

  @override
  Future<void> cycleRepeatMode() => _handler.cycleRepeatMode();

  @override
  Future<void> cycleSpeed() => _handler.cycleSpeed();

  Future<void> disposeController() async {
    await _subscription.cancel();
    await _handler.disposeHandler();
  }
}

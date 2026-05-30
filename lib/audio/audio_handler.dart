import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../data/repositories/player_repository.dart';
import '../data/services/saf_playback_path_resolver.dart';
import '../domain/enums/repeat_mode.dart';
import '../domain/models/playback_snapshot.dart';
import '../domain/models/track.dart';
import 'audio_playback_state.dart';
import 'play_context.dart';

/// `audio_service` handler — xem [audio.md].
class LocalMusicAudioHandler extends BaseAudioHandler with SeekHandler {
  LocalMusicAudioHandler({
    required PlayerRepository playerRepository,
    SafPlaybackPathResolver? pathResolver,
    Future<Track?> Function(String fileUri)? trackLookup,
  })  : _playerRepository = playerRepository,
        _pathResolver = pathResolver ?? SafPlaybackPathResolver(),
        _trackLookup = trackLookup ?? ((_) async => null) {
    _ready = _init();
  }

  late final Future<void> _ready;

  final PlayerRepository _playerRepository;
  final SafPlaybackPathResolver _pathResolver;
  final Future<Track?> Function(String fileUri) _trackLookup;
  final AudioPlayer _player = AudioPlayer();

  PlayContext? _playContext;
  RepeatMode _repeatMode = RepeatMode.off;
  double _speed = 1.0;
  String? _loadedFileRef;
  String? _playablePath;
  bool _isPreparing = false;
  Timer? _saveTimer;
  DateTime? _lastPositionUiBroadcast;
  static const _positionUiInterval = Duration(milliseconds: 120);

  final StreamController<AudioPlaybackState> _stateController =
      StreamController<AudioPlaybackState>.broadcast();

  AudioPlaybackState _state = const AudioPlaybackState();

  Stream<AudioPlaybackState> get uiStateStream => _stateController.stream;
  AudioPlaybackState get uiState => _state;

  String? get currentFileUri => _loadedFileRef;
  bool get isPreparing => _isPreparing;

  Future<void> ensureInitialized() => _ready;

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());

    _player.playbackEventStream.listen((event) {
      _broadcastPlaybackState();
      if (event.processingState == ProcessingState.completed) {
        unawaited(_onTrackCompleted());
      }
    });

    _player.positionStream.listen((_) {
      _scheduleSavePosition();
      _broadcastPositionIfDue();
    });

    _player.durationStream.listen((_) => _broadcastPlaybackState());
    _player.playingStream.listen((_) => _broadcastPlaybackState());

    await _restoreResume();
  }

  Future<void> _restoreResume() async {
    final snapshot = await _playerRepository.loadResume();
    if (snapshot == null) return;

    final track = await _trackLookup(snapshot.fileUri);
    if (track == null) return;

    try {
      _playContext = PlayContext(tracks: [track], currentIndex: 0);
      await _loadTrack(
        track,
        seek: Duration(milliseconds: snapshot.positionMs),
      );
      await _player.pause();
    } catch (e, st) {
      debugPrint('Resume failed: $e\n$st');
    }
  }

  Future<void> playTracks(List<Track> tracks, {required int startIndex}) async {
    if (tracks.isEmpty) return;
    final index = startIndex.clamp(0, tracks.length - 1);
    _playContext = PlayContext(tracks: tracks, currentIndex: index);
    await _loadTrack(tracks[index]);
    await _player.play();
  }

  Future<void> togglePlayPause() async {
    if (_player.playing) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> seekTo(Duration position) async {
    unawaited(_player.seek(position));
    _broadcastPlaybackStateImmediate();
  }

  Future<void> skipToNextTrack() async {
    final context = _playContext;
    if (context == null || !context.hasNext) return;
    final nextIndex = context.currentIndex + 1;
    _playContext = PlayContext(
      tracks: context.tracks,
      currentIndex: nextIndex,
    );
    await _loadTrack(context.tracks[nextIndex]);
    await _player.play();
  }

  Future<void> skipToPreviousTrack() async {
    final context = _playContext;
    if (context == null) return;

    if (_player.position.inSeconds > 3) {
      await _player.seek(Duration.zero);
      return;
    }

    if (!context.hasPrevious) {
      await _player.seek(Duration.zero);
      return;
    }

    final prevIndex = context.currentIndex - 1;
    _playContext = PlayContext(
      tracks: context.tracks,
      currentIndex: prevIndex,
    );
    await _loadTrack(context.tracks[prevIndex]);
    await _player.play();
  }

  Future<void> applyRepeatMode(RepeatMode mode) async {
    _repeatMode = mode;
    _broadcastPlaybackState();
  }

  Future<void> cycleRepeatMode() async {
    _repeatMode = switch (_repeatMode) {
      RepeatMode.off => RepeatMode.one,
      RepeatMode.one => RepeatMode.all,
      RepeatMode.all => RepeatMode.off,
    };
    _broadcastPlaybackState();
  }

  Future<void> cycleSpeed() async {
    const speeds = [0.75, 1.0, 1.25];
    final currentIndex = speeds.indexOf(_speed);
    final nextIndex = currentIndex < 0 ? 1 : (currentIndex + 1) % speeds.length;
    _speed = speeds[nextIndex];
    await _player.setSpeed(_speed);
    _broadcastPlaybackState();
  }

  Future<void> _onTrackCompleted() async {
    switch (_repeatMode) {
      case RepeatMode.one:
        await _player.seek(Duration.zero);
        await _player.play();
      case RepeatMode.all:
        final context = _playContext;
        if (context == null) return;
        if (context.hasNext) {
          await skipToNextTrack();
        } else if (context.tracks.isNotEmpty) {
          _playContext = PlayContext(tracks: context.tracks, currentIndex: 0);
          await _loadTrack(context.tracks.first);
          await _player.play();
        }
      case RepeatMode.off:
        final context = _playContext;
        if (context != null && context.hasNext) {
          await skipToNextTrack();
        } else {
          await _player.pause();
          await _player.seek(Duration.zero);
        }
    }
  }

  Future<void> _loadTrack(Track track, {Duration? seek}) async {
    _isPreparing = true;
    _broadcastPlaybackState();
    try {
      final playablePath = await _pathResolver.resolve(
        fileRef: track.fileUri,
        fileName: track.fileName,
      );
      if (_playablePath != playablePath) {
        await _player.setFilePath(playablePath);
        _playablePath = playablePath;
        _loadedFileRef = track.fileUri;
      }
      await _player.setSpeed(_speed);
      if (seek != null) {
        await _player.seek(seek);
      }
      await _updateMediaItem(track);
      _state = _state.copyWith(
        currentTrack: track,
        playContext: _playContext,
      );
    } finally {
      _isPreparing = false;
      _broadcastPlaybackState();
    }
  }

  Future<void> _updateMediaItem(Track track) async {
    mediaItem.add(
      MediaItem(
        id: track.fileUri,
        title: track.displayTitle,
        artist: track.displayArtist,
        album: track.album,
        duration: track.durationMs != null
            ? Duration(milliseconds: track.durationMs!)
            : null,
        artUri: track.artCachePath != null
            ? Uri.file(track.artCachePath!)
            : null,
      ),
    );
  }

  void _broadcastPositionIfDue() {
    if (!_player.playing) return;
    final now = DateTime.now();
    if (_lastPositionUiBroadcast != null &&
        now.difference(_lastPositionUiBroadcast!) < _positionUiInterval) {
      return;
    }
    _lastPositionUiBroadcast = now;
    _broadcastPlaybackState();
  }

  void _broadcastPlaybackStateImmediate() {
    _lastPositionUiBroadcast = DateTime.now();
    _broadcastPlaybackState();
  }

  void _broadcastPlaybackState() {
    _state = _state.copyWith(
      currentTrack: _playContext?.currentTrack,
      playContext: _playContext,
      playing: _player.playing,
      isPreparing: _isPreparing,
      position: _player.position,
      duration: _player.duration ?? Duration.zero,
      repeatMode: _repeatMode,
      speed: _speed,
    );
    if (!_stateController.isClosed) {
      _stateController.add(_state);
    }

    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (_player.playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 2],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: _playContext?.currentIndex,
      ),
    );
  }

  void _scheduleSavePosition() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 2), () {
      unawaited(_persistPosition());
    });
  }

  Future<void> _persistPosition() async {
    final track = _state.currentTrack;
    if (track == null) return;
    await _playerRepository.saveResume(
      PlaybackSnapshot(
        fileUri: track.fileUri,
        positionMs: _player.position.inMilliseconds,
      ),
    );
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() async {
    await _player.pause();
    await _persistPosition();
  }

  @override
  Future<void> seek(Duration position) => seekTo(position);

  @override
  Future<void> skipToNext() => skipToNextTrack();

  @override
  Future<void> skipToPrevious() => skipToPreviousTrack();

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  Future<void> disposeHandler() async {
    await _persistPosition();
    _saveTimer?.cancel();
    await _stateController.close();
    await _player.dispose();
  }
}

Future<LocalMusicAudioHandler> initAudioService({
  required PlayerRepository playerRepository,
  Future<Track?> Function(String fileUri)? trackLookup,
}) async {
  late LocalMusicAudioHandler handler;
  await AudioService.init(
    builder: () {
      handler = LocalMusicAudioHandler(
        playerRepository: playerRepository,
        trackLookup: trackLookup,
      );
      return handler;
    },
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.local_music_player.audio',
      androidNotificationChannelName: 'Local Music Player',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
  await handler.ensureInitialized();
  return handler;
}

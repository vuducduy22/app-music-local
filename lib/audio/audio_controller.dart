import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

import '../data/services/saf_playback_path_resolver.dart';

/// Điều khiển phát nhạc — hỗ trợ path file và `content://` (SAF).
abstract class AudioController {
  Stream<bool> get playingStream;
  String? get currentPath;
  bool get isPreparing;

  Future<void> init();
  Future<void> playFile(String fileRef, {required String fileName});
  Future<void> pause();
  Future<void> dispose();
}

class AudioControllerImpl implements AudioController {
  AudioControllerImpl({SafPlaybackPathResolver? pathResolver})
      : _pathResolver = pathResolver ?? SafPlaybackPathResolver(),
        _player = AudioPlayer();

  final SafPlaybackPathResolver _pathResolver;
  final AudioPlayer _player;
  String? _currentPath;
  String? _playablePath;
  bool _isPreparing = false;

  @override
  String? get currentPath => _currentPath;

  @override
  bool get isPreparing => _isPreparing;

  @override
  Stream<bool> get playingStream => _player.playingStream;

  @override
  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  @override
  Future<void> playFile(String fileRef, {required String fileName}) async {
    _isPreparing = true;
    try {
      final playablePath = await _pathResolver.resolve(
        fileRef: fileRef,
        fileName: fileName,
      );
      if (_playablePath != playablePath) {
        await _player.setFilePath(playablePath);
        _playablePath = playablePath;
        _currentPath = fileRef;
      }
      await _player.play();
    } finally {
      _isPreparing = false;
    }
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> dispose() async {
    await _player.dispose();
  }
}

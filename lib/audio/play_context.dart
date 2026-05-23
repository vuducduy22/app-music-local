import '../domain/models/track.dart';

/// Ngữ cảnh phát: danh sách + vị trí hiện tại — xem [audio.md].
class PlayContext {
  const PlayContext({
    required this.tracks,
    required this.currentIndex,
  });

  final List<Track> tracks;
  final int currentIndex;

  Track? get currentTrack =>
      currentIndex >= 0 && currentIndex < tracks.length
          ? tracks[currentIndex]
          : null;

  bool get hasNext => currentIndex < tracks.length - 1;
  bool get hasPrevious => currentIndex > 0;
}

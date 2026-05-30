/// Trạng thái resume phát nhạc — xem [models.md].
class PlaybackSnapshot {
  const PlaybackSnapshot({
    required this.fileUri,
    required this.positionMs,
  });

  final String fileUri;
  final int positionMs;
}

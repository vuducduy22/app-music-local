/// Kết quả đọc metadata từ file nhạc.
class TrackMetadataResult {
  const TrackMetadataResult({
    this.title,
    this.artist,
    this.album,
    this.durationMs,
    this.albumArtBytes,
    required this.missingTags,
  });

  final String? title;
  final String? artist;
  final String? album;
  final int? durationMs;
  final List<int>? albumArtBytes;
  final bool missingTags;
}

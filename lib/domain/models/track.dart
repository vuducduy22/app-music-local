/// Bài hát (domain) — xem [models.md].
class Track {
  const Track({
    required this.id,
    required this.fileUri,
    required this.fileName,
    this.title,
    this.artist,
    this.album,
    this.durationMs,
    this.artCachePath,
    this.customTitle,
    this.customArtist,
    this.missingTags = false,
  });

  final int id;
  final String fileUri;
  final String fileName;
  final String? title;
  final String? artist;
  final String? album;
  final int? durationMs;
  final String? artCachePath;
  final String? customTitle;
  final String? customArtist;
  final bool missingTags;

  String get displayTitle =>
      _firstNonEmpty([customTitle, title, fileName]) ?? fileName;

  String get displayArtist =>
      _firstNonEmpty([customArtist, artist]) ?? '';

  static String? _firstNonEmpty(List<String?> values) {
    for (final v in values) {
      if (v != null && v.trim().isNotEmpty) return v.trim();
    }
    return null;
  }
}

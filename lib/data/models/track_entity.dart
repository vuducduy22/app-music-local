import '../../domain/models/track.dart';

/// Hàng SQLite `tracks` — xem [data_models.md].
class TrackEntity {
  const TrackEntity({
    required this.id,
    required this.fileUri,
    required this.fileName,
    this.title,
    this.artist,
    this.album,
    this.durationMs,
    this.artCachePath,
    this.dominantColor,
    this.customTitle,
    this.customArtist,
    this.missingTags = false,
    required this.fileModifiedAtMs,
    required this.lastSeenAtMs,
    required this.createdAtMs,
  });

  final int id;
  final String fileUri;
  final String fileName;
  final String? title;
  final String? artist;
  final String? album;
  final int? durationMs;
  final String? artCachePath;
  final int? dominantColor;
  final String? customTitle;
  final String? customArtist;
  final bool missingTags;
  final int fileModifiedAtMs;
  final int lastSeenAtMs;
  final int createdAtMs;

  Track toDomain() => Track(
        id: id,
        fileUri: fileUri,
        fileName: fileName,
        title: title,
        artist: artist,
        album: album,
        durationMs: durationMs,
        artCachePath: artCachePath,
        customTitle: customTitle,
        customArtist: customArtist,
        missingTags: missingTags,
      );

  Map<String, Object?> toMap() => {
        'id': id,
        'file_uri': fileUri,
        'file_name': fileName,
        'title': title,
        'artist': artist,
        'album': album,
        'duration_ms': durationMs,
        'art_cache_path': artCachePath,
        'dominant_color': dominantColor,
        'custom_title': customTitle,
        'custom_artist': customArtist,
        'missing_tags': missingTags ? 1 : 0,
        'file_modified_at': fileModifiedAtMs,
        'last_seen_at': lastSeenAtMs,
        'created_at': createdAtMs,
      };

  static TrackEntity fromMap(Map<String, Object?> map) => TrackEntity(
        id: map['id']! as int,
        fileUri: map['file_uri']! as String,
        fileName: map['file_name']! as String,
        title: map['title'] as String?,
        artist: map['artist'] as String?,
        album: map['album'] as String?,
        durationMs: map['duration_ms'] as int?,
        artCachePath: map['art_cache_path'] as String?,
        dominantColor: map['dominant_color'] as int?,
        customTitle: map['custom_title'] as String?,
        customArtist: map['custom_artist'] as String?,
        missingTags: (map['missing_tags'] as int? ?? 0) == 1,
        fileModifiedAtMs: map['file_modified_at']! as int,
        lastSeenAtMs: map['last_seen_at']! as int,
        createdAtMs: map['created_at']! as int,
      );

  TrackEntity copyWith({
    int? id,
    String? fileUri,
    String? fileName,
    String? title,
    String? artist,
    String? album,
    int? durationMs,
    String? artCachePath,
    int? dominantColor,
    String? customTitle,
    String? customArtist,
    bool? missingTags,
    int? fileModifiedAtMs,
    int? lastSeenAtMs,
    int? createdAtMs,
  }) {
    return TrackEntity(
      id: id ?? this.id,
      fileUri: fileUri ?? this.fileUri,
      fileName: fileName ?? this.fileName,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      durationMs: durationMs ?? this.durationMs,
      artCachePath: artCachePath ?? this.artCachePath,
      dominantColor: dominantColor ?? this.dominantColor,
      customTitle: customTitle ?? this.customTitle,
      customArtist: customArtist ?? this.customArtist,
      missingTags: missingTags ?? this.missingTags,
      fileModifiedAtMs: fileModifiedAtMs ?? this.fileModifiedAtMs,
      lastSeenAtMs: lastSeenAtMs ?? this.lastSeenAtMs,
      createdAtMs: createdAtMs ?? this.createdAtMs,
    );
  }
}

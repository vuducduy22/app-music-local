import '../../../core/constants/db_constants.dart';
import '../../../domain/enums/sort_option.dart';
import '../../models/track_entity.dart';
import '../app_database.dart';

/// CRUD bảng `tracks` — xem [daos.md].
class TrackDao {
  TrackDao(this._database);

  final AppDatabase _database;

  Future<TrackEntity> insert(TrackEntity entity) async {
    final db = await _database.database;
    final id = await db.insert(
      DbConstants.tracksTable,
      entity.toMap()..remove('id'),
    );
    return entity.copyWith(id: id);
  }

  Future<void> update(TrackEntity entity) async {
    final db = await _database.database;
    await db.update(
      DbConstants.tracksTable,
      entity.toMap(),
      where: 'id = ?',
      whereArgs: [entity.id],
    );
  }

  Future<TrackEntity?> findByUri(String fileUri) async {
    final db = await _database.database;
    final rows = await db.query(
      DbConstants.tracksTable,
      where: 'file_uri = ?',
      whereArgs: [fileUri],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return TrackEntity.fromMap(rows.first);
  }

  Future<TrackEntity?> findById(int id) async {
    final db = await _database.database;
    final rows = await db.query(
      DbConstants.tracksTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return TrackEntity.fromMap(rows.first);
  }

  Future<void> deleteWhereLastSeenBefore(int batchMs) async {
    final db = await _database.database;
    await db.delete(
      DbConstants.tracksTable,
      where: 'last_seen_at < ?',
      whereArgs: [batchMs],
    );
  }

  Future<void> deleteAll() async {
    final db = await _database.database;
    await db.delete(DbConstants.tracksTable);
  }

  Future<List<TrackEntity>> getAll({
    String? query,
    SortOption sort = SortOption.fileName,
  }) async {
    final db = await _database.database;
    final trimmed = query?.trim();
    final hasQuery = trimmed != null && trimmed.isNotEmpty;
    final like = hasQuery ? '%$trimmed%' : null;

    final rows = await db.query(
      DbConstants.tracksTable,
      where: hasQuery
          ? '''
            file_name LIKE ? COLLATE NOCASE OR
            title LIKE ? COLLATE NOCASE OR
            artist LIKE ? COLLATE NOCASE OR
            custom_title LIKE ? COLLATE NOCASE OR
            custom_artist LIKE ? COLLATE NOCASE
          '''
          : null,
      whereArgs: hasQuery ? [like, like, like, like, like] : null,
      orderBy: _orderByClause(sort),
    );
    return rows.map(TrackEntity.fromMap).toList();
  }

  Future<void> updateCustomFields({
    required int trackId,
    required String? customTitle,
    required String? customArtist,
    required bool missingTags,
  }) async {
    final db = await _database.database;
    await db.update(
      DbConstants.tracksTable,
      {
        'custom_title': customTitle,
        'custom_artist': customArtist,
        'missing_tags': missingTags ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [trackId],
    );
  }

  String _orderByClause(SortOption sort) => switch (sort) {
        SortOption.fileName => 'file_name COLLATE NOCASE ASC',
        SortOption.title =>
          'COALESCE(custom_title, title, file_name) COLLATE NOCASE ASC',
        SortOption.artist =>
          'COALESCE(custom_artist, artist, \'\') COLLATE NOCASE ASC',
        SortOption.dateAdded => 'created_at DESC',
      };
}

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../core/constants/db_constants.dart';

/// SQLite — xem [local.md].
class AppDatabase {
  AppDatabase();

  Database? _db;

  Future<Database> get database async {
    return _db ??= await _open();
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, DbConstants.dbName);

    return openDatabase(
      path,
      version: DbConstants.dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${DbConstants.tracksTable} (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            file_uri TEXT NOT NULL UNIQUE,
            file_name TEXT NOT NULL,
            title TEXT,
            artist TEXT,
            album TEXT,
            duration_ms INTEGER,
            art_cache_path TEXT,
            dominant_color INTEGER,
            custom_title TEXT,
            custom_artist TEXT,
            missing_tags INTEGER NOT NULL DEFAULT 0,
            file_modified_at INTEGER NOT NULL,
            last_seen_at INTEGER NOT NULL,
            created_at INTEGER NOT NULL
          )
        ''');
        await db.execute(
          'CREATE INDEX idx_tracks_last_seen ON ${DbConstants.tracksTable}(last_seen_at)',
        );
      },
    );
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}

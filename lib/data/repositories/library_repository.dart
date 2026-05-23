import '../../domain/models/track.dart';

/// Thư viện nhạc — xem [repositories.md].
abstract class LibraryRepository {
  Future<List<Track>> getTracks();
  Future<void> refreshLibrary();
}

class LibraryRepositoryImpl implements LibraryRepository {
  @override
  Future<List<Track>> getTracks() async => [];

  @override
  Future<void> refreshLibrary() async {
    // TODO(M0): gọi LibraryScanner + merge DB
  }
}

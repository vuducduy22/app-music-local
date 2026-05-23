/// Quét thư mục nhạc — xem [library_scanner.md].
abstract class LibraryScanner {
  Future<List<String>> listAudioFileUris(String folderTreeUri);
}

class LibraryScannerImpl implements LibraryScanner {
  @override
  Future<List<String>> listAudioFileUris(String folderTreeUri) async {
    // TODO(M0): đệ quy SAF
    return [];
  }
}

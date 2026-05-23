/// File nhạc quét từ thư mục (M0 — chưa có DB).
class ScannedAudioFile {
  const ScannedAudioFile({
    required this.path,
    required this.fileName,
  });

  final String path;
  final String fileName;
}

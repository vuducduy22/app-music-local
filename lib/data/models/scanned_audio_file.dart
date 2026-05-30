/// File nhạc quét từ thư mục.
class ScannedAudioFile {
  const ScannedAudioFile({
    required this.path,
    required this.fileName,
    this.modifiedAtMs,
  });

  final String path;
  final String fileName;

  /// Thời điểm sửa file (ms). SAF có thể null.
  final int? modifiedAtMs;
}

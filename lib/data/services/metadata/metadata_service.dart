/// Đọc ID3 / metadata — xem [metadata.md].
abstract class MetadataService {
  Future<Map<String, dynamic>> readFromUri(String fileUri);
}

class MetadataServiceImpl implements MetadataService {
  @override
  Future<Map<String, dynamic>> readFromUri(String fileUri) async {
    // TODO(M1): flutter_media_metadata hoặc tương đương
    return {};
  }
}

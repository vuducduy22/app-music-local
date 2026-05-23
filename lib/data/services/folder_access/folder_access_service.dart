/// SAF / chọn folder — xem [folder_access.md].
abstract class FolderAccessService {
  Future<String?> pickMusicFolder();
  Future<bool> hasValidFolderAccess(String treeUri);
}

class FolderAccessServiceImpl implements FolderAccessService {
  @override
  Future<String?> pickMusicFolder() async {
    // TODO(M0): file_picker hoặc platform SAF
    return null;
  }

  @override
  Future<bool> hasValidFolderAccess(String treeUri) async => false;
}

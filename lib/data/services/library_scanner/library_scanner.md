# library_scanner — Quét file nhạc đệ quy

## Việc cần làm

- [x] Duyệt **đệ quy** mọi subfolder từ `treeUri`
- [x] Lọc extension theo `AppConstants.supportedAudioExtensions`
- [x] Trả danh sách path/uri + `modifiedAt` (filesystem; SAF có thể null)
- [x] **Merge vào DB** qua `LibraryRepository.refreshLibrary()`
- [ ] Chạy isolate/`compute` nếu thư viện lớn

## File

- `library_scanner.dart`

## Feature liên quan

`features/library` (nút Refresh)

## Phase

M0 (list file) → M1 (merge SQLite)

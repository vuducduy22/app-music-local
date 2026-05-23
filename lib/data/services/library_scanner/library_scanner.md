# library_scanner — Quét file nhạc đệ quy

## Việc cần làm

- [ ] Duyệt **đệ quy** mọi subfolder từ `treeUri`
- [ ] Lọc extension theo `AppConstants.supportedAudioExtensions`
- [ ] Trả danh sách path/uri + `modifiedAt`
- [ ] **Merge vào DB**: bài mới, đổi file, xóa bài không còn `last_seen`
- [ ] Chạy isolate/`compute` nếu thư viện lớn

## File

- `library_scanner.dart`

## Feature liên quan

`features/library` (nút Refresh)

## Phase

M0 (list file) → M1 (merge SQLite)

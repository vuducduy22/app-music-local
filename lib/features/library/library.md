# library — Thư viện nhạc (danh sách bài)

## Mục đích

Màn **chính**: hiển thị bài từ DB, **Refresh**, **tìm kiếm**, **sắp xếp**, tap để phát.

## Việc cần làm

- [ ] `ListView` / sliver danh sách `Track` (ảnh bìa, title, artist)
- [x] AppBar: nút **Đổi thư mục** (folder) + **Refresh**
- [ ] AppBar: search, sort menu
- [ ] `LibraryViewModel`: load từ `LibraryRepository`, trạng thái loading/error
- [ ] Refresh → `library_repository.refreshLibrary()` → notify
- [ ] Tap bài → `AudioController.playTrack(PlayContext(...))`
- [ ] `missingTags` → badge "Chưa có tên"; **vẫn phát**; tap badge → `track_edit` (tùy chọn)
- [ ] Empty state: chưa refresh / chưa có folder

## Widget con (tùy chọn)

- `widgets/track_list_tile.dart`
- `widgets/library_app_bar.dart`

## File

- `library_screen.dart`
- `library_view_model.dart`

## Phase

**M0** list + refresh + play  
**M1** ID3 + art + search/sort

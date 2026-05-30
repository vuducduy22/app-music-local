# library — Thư viện nhạc (danh sách bài)

## Mục đích

Màn **chính**: hiển thị bài từ DB, **Refresh**, **tìm kiếm**, **sắp xếp**, tap để phát.

## Việc cần làm

- [x] `ListView` danh sách `Track` (ảnh bìa, title, artist)
- [x] AppBar: nút **Đổi thư mục** (folder) + **Refresh**
- [x] AppBar: search, sort menu
- [x] `LibraryViewModel`: load từ `LibraryRepository`, trạng thái loading/error
- [x] Refresh → `library_repository.refreshLibrary()` → notify
- [x] Tap bài → `AudioController` + `PlayContext` (queue = list hiện tại)
- [x] `missingTags` → badge "Chưa có tên"; **vẫn phát**; tap badge → `track_edit`
- [x] Empty state: chưa có file / hướng dẫn refresh

## Widget con (tùy chọn)

- `widgets/track_list_tile.dart`
- `widgets/library_app_bar.dart`

## File

- `library_screen.dart`
- `library_view_model.dart`

## Phase

**M0** list + refresh + play  
**M1** ID3 + art + search/sort

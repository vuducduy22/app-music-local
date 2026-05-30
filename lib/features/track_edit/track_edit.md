# track_edit — Sửa tên khi thiếu tag

## Mục đích

File **không có** title/artist trong tag → user **điền tên hiển thị** (lưu `custom_title` / `custom_artist` trong DB).

## Việc cần làm

- [x] File `track_edit_screen.dart` — form lưu custom title/artist
- [x] Màn form: tên bài, tên nghệ sĩ (tùy chọn)
- [x] Lưu qua `LibraryRepository.updateCustomMetadata`
- [x] Clear `missing_tags` sau khi lưu tên hợp lệ
- [x] **Vẫn cho phát** khi thiếu tag; badge "Chưa có tên" trên list
- [x] Mở từ Library (badge / long press)

## File

- `track_edit_screen.dart`
- `track_edit_view_model.dart`

## Phase

**M1** (sau metadata đọc được `missing_tags`)

# track_edit — Sửa tên khi thiếu tag

## Mục đích

File **không có** title/artist trong tag → user **điền tên hiển thị** (lưu `custom_title` / `custom_artist` trong DB).

## Việc cần làm

- [ ] Màn / bottom sheet: form tên bài, tên nghệ sĩ (tùy chọn)
- [ ] Lưu qua `LibraryRepository` hoặc `TrackDao`
- [ ] Clear `missing_tags` sau khi lưu hợp lệ
- [ ] **Vẫn cho phát** khi thiếu tag; badge "Chưa có tên" trên list
- [ ] Mở từ Library (badge) — **không** chặn phát

## File

- `track_edit_screen.dart`
- `track_edit_view_model.dart`

## Phase

**M1** (sau metadata đọc được `missing_tags`)

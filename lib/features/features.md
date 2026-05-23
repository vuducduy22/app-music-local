# features — Tính năng theo màn hình (MVVM)

Mỗi feature = **folder riêng** + file **`tên_feature.md`** mô tả việc cần làm.

## Cấu trúc chuẩn mỗi feature

```text
features/<tên>/
  <tên>.md              ← đọc trước khi code
  <tên>_screen.dart     ← UI
  <tên>_view_model.dart ← state + gọi repository
  widgets/              ← (tùy chọn) widget con
```

## Danh sách feature

| Folder | Phase | Mô tả ngắn |
|--------|-------|------------|
| `shell/` | M2 | Khung app: nav + mini player |
| `onboarding/` | M0 | Chọn thư mục lần đầu |
| `library/` | M0–M1 | Danh sách, search, sort, refresh |
| `player/` | M2 | Màn phát đầy đủ |
| `playlists/` | M3 | CRUD playlist |
| `favorites/` | M3 | Yêu thích |
| `history/` | M3 | Lịch sử nghe |
| `settings/` | M3 | Folder, theme, ngôn ngữ |
| `track_edit/` | M1 | Sửa tên khi thiếu tag |
| `backup/` | M4 | Export/import |

## Luồng điều hướng

`main` → `ShellScreen` → nếu chưa folder → `OnboardingScreen` → `LibraryScreen` (+ các tab khác).

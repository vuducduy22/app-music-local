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

| Folder | Phase | Tiến độ | Mô tả ngắn |
|--------|-------|---------|------------|
| `onboarding/` | M0 | ✅ | Chọn thư mục lần đầu |
| `library/` | M0–M1 | ✅ M0 | List/refresh/play xong; M1 search/sort/ID3 |
| `shell/` | M2 | 🔶 | Khung UI có file, chưa dùng trong app |
| `player/` | M2 | 🔶 | Placeholder + mini bar khung |
| `playlists/` | M3 | ⏳ | CRUD playlist |
| `favorites/` | M3 | ⏳ | Yêu thích |
| `history/` | M3 | ⏳ | Lịch sử nghe |
| `settings/` | M3 | 🔶 | Placeholder; đổi folder tạm ở Library |
| `track_edit/` | M1 | ⏳ | Sửa tên khi thiếu tag |
| `backup/` | M4 | ⏳ | Export/import |

## Luồng điều hướng (hiện tại)

`main` → `AppStartup` → nếu chưa folder → `OnboardingScreen` → `LibraryScreen`.

*(Kế hoạch v1: qua `ShellScreen` + bottom nav + mini player.)*

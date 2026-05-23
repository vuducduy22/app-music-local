# Cấu trúc mã nguồn — Local Music Player

Mỗi thư mục có file **`.md` cùng tên thư mục** (hoặc tên module) mô tả phạm vi và việc cần làm.

**UI (màu, font, component):** bám theo **[`core/theme/DESIGN_SYSTEM.md`](core/theme/DESIGN_SYSTEM.md)** — không tự đặt màu/font trong từng feature.

## Thứ tự triển khai gợi ý

| Phase | Thư mục / tính năng |
|-------|---------------------|
| M0 | `core/`, `data/` (folder + scan cơ bản), `features/onboarding`, `features/library`, `audio/` (play đơn) |
| M1 | `data/` (SQLite, metadata), `features/library` (search/sort) |
| M2 | `audio/`, `features/player`, `features/shell` |
| M3 | `features/playlists`, `favorites`, `history`, `settings`, `track_edit` |
| M4 | `data/services/backup`, `features/backup` |

## Cây thư mục

```text
lib/
  app.dart
  main.dart
  core/
  domain/
  data/
  audio/
  features/
    shell/
    onboarding/
    library/
    player/
    playlists/
    favorites/
    history/
    settings/
    track_edit/
    backup/
```

Chi tiết từng folder → mở file `tên_folder.md` trong folder đó.

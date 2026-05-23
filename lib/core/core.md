# core — Hạ tầng dùng chung

## Mục đích

Chứa code **không thuộc một tính năng UI cụ thể**: hằng số, theme, đa ngôn ngữ, tiện ích, dependency injection.

## Việc cần làm

- [ ] Định nghĩa extension file nhạc (`.mp3`, `.flac`, …)
- [ ] Key `SharedPreferences` / settings keys
- [ ] Theme Dark / Light (xem DESIGN_SYSTEM.md)
- [ ] ARB / l10n Tiếng Việt + English
- [ ] `get_it` (hoặc tương đương): đăng ký DB, repositories, `AudioHandler`
- [ ] Helper format thời lượng, chuỗi tìm kiếm

## Phụ thuộc

Không import `features/*`. Được import bởi mọi layer khác.

## Thư mục con

| Folder | File mô tả |
|--------|----------------|
| `constants/` | `constants.md` |
| `theme/` | `theme.md` |
| `l10n/` | `l10n.md` |
| `utils/` | `utils.md` |
| `di/` | `di.md` |

## Phase

M0 (constants cơ bản) → M3 (theme + l10n đầy đủ)

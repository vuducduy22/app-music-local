# core — Hạ tầng dùng chung

## Mục đích

Chứa code **không thuộc một tính năng UI cụ thể**: hằng số, theme, đa ngôn ngữ, tiện ích, dependency injection.

## Việc cần làm

- [x] Định nghĩa extension file nhạc (`.mp3`, `.flac`, …) — `AppConstants`
- [x] Key `SharedPreferences` / settings keys — `PrefsKeys.musicFolderPath`
- [x] Theme Dark cơ bản — `app_theme_data.dart` (M0)
- [ ] Theme Dark / Light đầy đủ (xem DESIGN_SYSTEM.md) — M3
- [ ] ARB / l10n Tiếng Việt + English
- [x] DI M0 — `AppDependencies.init()` (thay `get_it` tạm thời)
- [ ] `get_it` + đăng ký DB, `AudioHandler` — M1/M2
- [x] Quyền Android — `android_permissions.dart`
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

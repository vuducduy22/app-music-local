# settings — Cài đặt

## Mục đích

Folder nhạc, theme màu, ngôn ngữ, repeat/speed mặc định (tùy chọn), battery tip.

## Việc cần làm

- [x] Hiển thị / đổi **thư mục nhạc** — M0: nút trên `LibraryScreen` AppBar (chưa màn Settings)
- [ ] Màn Settings: xem / đổi folder — M3
- [ ] Chọn **theme** Dark / Light (UI v1); lưu `theme_mode` enum 3 (`dark`/`light`/`system`)
- [ ] Chọn **ngôn ngữ** VI / EN
- [ ] Link mở **Export/Import** (`features/backup`)
- [ ] Phiên bản app
- [x] File `settings_screen.dart` — placeholder UI

## File

- `settings_screen.dart`
- `settings_view_model.dart`

## Phase

**M3** (folder có thể tái dùng từ onboarding sớm hơn)

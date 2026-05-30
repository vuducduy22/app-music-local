# theme — Giao diện & màu preset

## Design system (bắt buộc đọc trước khi làm UI)

👉 **[`DESIGN_SYSTEM.md`](DESIGN_SYSTEM.md)** — màu, font, spacing, component spec.

## Việc cần làm

- [ ] Implement đầy đủ theo `DESIGN_SYSTEM.md`
- [x] `app_theme.dart` — `AppThemeKey.dark` / `.light`, `AppThemeMode`
- [x] `app_theme_data.dart` — `ThemeData` dark M0 (chưa Inter / `google_fonts`)
- [ ] `app_theme_data.dart` — theme light
- [ ] `app_colors.dart` — hex §5 DESIGN_SYSTEM
- [ ] `artwork_palette_service.dart` + `player_gradient.dart` — dynamic color Player
- [ ] `ThemeNotifier` / đọc từ `SettingsRepository`
- [x] Áp dụng dark lên `MaterialApp` trong `app.dart` (chưa chọn theme trong Settings)

## File dự kiến

- `app_theme.dart`
- `app_theme_data.dart`
- `app_colors.dart`

## Phase

M0: **dark** mặc định · M3: chọn Dark/Light trong Settings · Player gradient: M2

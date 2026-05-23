# theme — Giao diện & màu preset

## Design system (bắt buộc đọc trước khi làm UI)

👉 **[`DESIGN_SYSTEM.md`](DESIGN_SYSTEM.md)** — màu, font, spacing, component spec.

## Việc cần làm

- [ ] Implement theo `DESIGN_SYSTEM.md`
- [ ] `app_theme.dart` — `AppThemeKey.dark` / `.light` (2 preset)
- [ ] `app_theme_data.dart` — `ThemeData` + Inter (`google_fonts`)
- [ ] `app_colors.dart` — hex §5 DESIGN_SYSTEM
- [ ] `artwork_palette_service.dart` + `player_gradient.dart` — dynamic color Player
- [ ] `ThemeNotifier` / đọc từ `SettingsRepository`
- [ ] Áp dụng lên `MaterialApp` trong `app.dart`

## File dự kiến

- `app_theme.dart`
- `app_theme_data.dart`
- `app_colors.dart`

## Phase

M0: **dark** mặc định · M3: chọn Dark/Light trong Settings · Player gradient: M2

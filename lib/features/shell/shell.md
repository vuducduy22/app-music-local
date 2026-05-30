# shell — Khung ứng dụng chính

## Mục đích

Container sau onboarding: **điều hướng** giữa các tab/màn và chỗ gắn **mini player bar**.

## Việc cần làm

- [x] `ShellScreen` — `Scaffold` + `NavigationBar`
- [x] Tab: Library, Playlists, History, Settings — `IndexedStack`
- [x] `body`: `IndexedStack`
- [x] `Column`: `MiniPlayerBar` + nav
- [x] Tap mini bar → `PlayerScreen` (~250ms)
- [x] Redirect onboarding — `AppStartup` → `ShellScreen`

## File

- `shell_screen.dart`
- `shell_view_model.dart` (optional — tab index, deep link)

## Phụ thuộc

`onboarding`, `library`, `playlists`, `history`, `settings`, `player` (mini bar widget)

## Phase

M2 (sau player mini bar)

# shell — Khung ứng dụng chính

## Mục đích

Container sau onboarding: **điều hướng** giữa các tab/màn và chỗ gắn **mini player bar**.

## Việc cần làm

- [ ] `ShellScreen` — `Scaffold` + `NavigationBar` / `Drawer`
- [ ] Tab: Library, Playlists, History, Settings
- [ ] `body`: `IndexedStack` hoặc routes con
- [ ] `bottomNavigationBar` hoặc `Column`: `MiniPlayerBar` + nav
- [ ] Điều hướng tới `PlayerScreen` (full) khi tap mini bar
- [ ] Redirect onboarding nếu chưa có folder

## File

- `shell_screen.dart`
- `shell_view_model.dart` (optional — tab index, deep link)

## Phụ thuộc

`onboarding`, `library`, `playlists`, `history`, `settings`, `player` (mini bar widget)

## Phase

M2 (sau player mini bar)

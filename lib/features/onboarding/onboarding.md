# onboarding — Lần đầu: chọn thư mục nhạc

## Mục đích

Hướng dẫn user **chọn folder** chứa nhạc (SAF). Sau khi xong → vào `ShellScreen` / Library.

## Việc cần làm

- [x] Màn giới thiệu ngắn + nút **「Chọn thư mục」**
- [x] Gọi `FolderAccessService.pickMusicFolder()`
- [x] Lưu URI qua `SettingsRepository`
- [x] Gợi ý bấm **Refresh** ở Library lần đầu — SnackBar sau onboarding
- [x] Không hiện lại nếu đã có folder (trừ khi xóa trong Settings)

## File

- `onboarding_screen.dart`
- `onboarding_view_model.dart`

## Phase

**M0** — làm đầu tiên cùng `folder_access`

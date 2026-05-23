# onboarding — Lần đầu: chọn thư mục nhạc

## Mục đích

Hướng dẫn user **chọn folder** chứa nhạc (SAF). Sau khi xong → vào `ShellScreen` / Library.

## Việc cần làm

- [ ] Màn giới thiệu ngắn + nút **「Chọn thư mục」**
- [ ] Gọi `FolderAccessService.pickMusicFolder()`
- [ ] Lưu URI qua `SettingsRepository`
- [ ] Gợi ý bấm **Refresh** ở Library lần đầu
- [ ] Không hiện lại nếu đã có folder (trừ khi xóa trong Settings)

## File

- `onboarding_screen.dart`
- `onboarding_view_model.dart`

## Phase

**M0** — làm đầu tiên cùng `folder_access`

# audio — Phát nhạc & phát nền

## Mục đích

**Một** pipeline phát nhạc cho toàn app: `just_audio` + `audio_service`.

## Việc cần làm

- [ ] `MyAudioHandler` extends `BaseAudioHandler` — mediaItem, playbackState
- [ ] `AudioController` — set source, play/pause, seek, speed, repeat
- [ ] Next/previous theo `PlayContext` (list + index) từ ViewModel
- [ ] Notification + điều khiển màn hình khóa
- [ ] Debounce lưu position → `PlayerRepository`
- [ ] Đăng ký handler trong `main.dart` trước `runApp`

## File

| File | Vai trò |
|------|---------|
| `audio_handler.dart` | `audio_service` integration |
| `audio_controller.dart` | Facade cho UI/VM |
| `play_context.dart` | Danh sách đang phát + index |

## Không làm

- Widget UI (thuộc `features/player`)

## Feature liên quan

`features/player`, `features/shell` (mini bar)

## Phase

M0 (play/pause đơn) → M2 (đầy đủ nền + seek + speed + repeat + resume)

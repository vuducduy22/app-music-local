# audio — Phát nhạc & phát nền

## Mục đích

**Một** pipeline phát nhạc cho toàn app: `just_audio` + `audio_service`.

## Việc cần làm

- [x] `MyAudioHandler` extends `BaseAudioHandler` — mediaItem, playbackState
- [x] `AudioController` — play/pause, seek, speed, repeat
- [x] `PlayContext` — nối next/previous theo list thư viện
- [x] Next/previous theo `PlayContext`
- [x] Notification + điều khiển màn hình khóa (`audio_service`)
- [x] Debounce lưu position → `PlayerRepository`
- [x] Khởi tạo handler trong `AppDependencies.init()`

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

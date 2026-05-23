# repositories — API dữ liệu cho features

## Việc cần làm

| File | Trách nhiệm |
|------|-------------|
| `library_repository.dart` | refresh scan, list tracks, search, sort |
| `playlist_repository.dart` | CRUD playlist, thêm/xóa bài, đổi thứ tự |
| `favorite_repository.dart` | toggle favorite, list favorites |
| `history_repository.dart` | ghi / list lịch sử |
| `player_repository.dart` | load/save playback resume, speed, repeat |
| `settings_repository.dart` | folder URI, theme, locale |

## Nguyên tắc

ViewModel **chỉ** gọi repository, không gọi DAO trực tiếp.

## Phase

M0–M1: `library`, `settings`  
M2: `player`  
M3: còn lại

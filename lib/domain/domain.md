# domain — Model & enum thuần Dart

## Mục đích

Định nghĩa **nghiệp vụ thuần** (không Flutter, không SQLite): `Track`, `Playlist`, `RepeatMode`, …

UI và `data/` map qua lại entity ↔ model domain.

## Việc cần làm

- [x] Model: `Track` (domain — chưa nối DB/list UI)
- [ ] Model: `Playlist`, `PlaylistEntry`, `PlayHistoryEntry`
- [x] Enum: `RepeatMode`
- [ ] Enum: `SortOption`, `ScanResult`
- [x] Getter hiển thị: `displayTitle`, `displayArtist` (trên `Track`)

## Không làm ở đây

- Widget, `BuildContext`
- `sqflite`, `just_audio`

## Thư mục con

- `models/` → `models.md`
- `enums/` → `enums.md`

## Phase

M1 (cùng SQLite)

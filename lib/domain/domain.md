# domain — Model & enum thuần Dart

## Mục đích

Định nghĩa **nghiệp vụ thuần** (không Flutter, không SQLite): `Track`, `Playlist`, `RepeatMode`, …

UI và `data/` map qua lại entity ↔ model domain.

## Việc cần làm

- [ ] Model: `Track`, `Playlist`, `PlaylistEntry`, `PlayHistoryEntry`
- [ ] Enum: `RepeatMode`, `SortOption`, `ScanResult`
- [ ] Getter hiển thị: `displayTitle`, `displayArtist` (ưu tiên custom → tag → fileName)

## Không làm ở đây

- Widget, `BuildContext`
- `sqflite`, `just_audio`

## Thư mục con

- `models/` → `models.md`
- `enums/` → `enums.md`

## Phase

M1 (cùng SQLite)

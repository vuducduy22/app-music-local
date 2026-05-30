# data models — Entity / DTO (tầng data)

## Mục đích

Map `Map<String, dynamic>` từ SQLite ↔ `domain/models`.

## Việc cần làm

- [x] `scanned_audio_file.dart` — M0: path + fileName từ quét (chưa DB)
- [ ] `track_entity.dart` — `fromMap` / `toMap` / `toDomain()` — M1
- [ ] Tương tự playlist, history nếu cần tách khỏi DAO

## Phase

M1

# metadata — Đọc tag ID3 & ảnh bìa

## Việc cần làm

- [x] File `metadata_service.dart` — `audio_metadata_reader` (pure Dart)
- [x] Đọc title, artist, album, duration từ file
- [x] Extract embedded art → lưu cache `art_cache_path`
- [ ] `palette_generator` → lưu `dominant_color` (ARGB) — M2 Player
- [x] Đánh dấu `missing_tags` khi không có title/artist
- [x] Chỉ đọc lại khi `file_modified_at` thay đổi (filesystem)

## File

- `metadata_service.dart`

## Feature liên quan

`features/library`, `features/track_edit`

## Phase

M1

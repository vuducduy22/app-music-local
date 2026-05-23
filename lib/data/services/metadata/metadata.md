# metadata — Đọc tag ID3 & ảnh bìa

## Việc cần làm

- [ ] Đọc title, artist, album, duration từ file
- [ ] Extract embedded art → lưu cache `art_cache_path`
- [ ] `palette_generator` → lưu `dominant_color` (ARGB) cho Player gradient
- [ ] Đánh dấu `missing_tags` khi không có title/artist
- [ ] Chỉ đọc lại khi `file_modified_at` thay đổi

## File

- `metadata_service.dart`

## Feature liên quan

`features/library`, `features/track_edit`

## Phase

M1

# data — Truy cập dữ liệu & dịch vụ

## Mục đích

SQLite, quét thư mục, đọc metadata, repository cho từng miền dữ liệu.

**Không** chứa Widget UI.

## Việc cần làm (tổng)

- [x] Mở/migrate DB v1 — `AppDatabase`
- [x] DAO tracks — M1
- [ ] DAO playlists, favorites, history, settings — M3
- [x] Repository — `library`, `settings`
- [x] Service metadata — M1

## Thư mục con

| Folder | Mô tả |
|--------|--------|
| `local/` | SQLite + DAO |
| `models/` | Map row ↔ entity |
| `repositories/` | API cho features |
| `services/` | Folder, scan, metadata, backup |

## Phase

M0: folder + list file  
M1: DB + metadata + merge scan  
M4: backup

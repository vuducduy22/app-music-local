# data — Truy cập dữ liệu & dịch vụ

## Mục đích

SQLite, quét thư mục, đọc metadata, repository cho từng miền dữ liệu.

**Không** chứa Widget UI.

## Việc cần làm (tổng)

- [ ] Mở/migrate DB
- [ ] DAO CRUD tracks, playlists, favorites, history, settings
- [ ] Repository che giấu SQL khỏi ViewModel
- [ ] Services: SAF folder, scanner đệ quy, metadata, backup

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

# Quyết định thiết kế — Local Music Player

> Tổng hợp từ [`traloi.md`](traloi.md) · Cập nhật: 2026-05-23

---

## Tóm tắt một trang

| Hạng mục | Quyết định |
|----------|------------|
| Phạm vi | Chỉ **một máy**, chỉ **Android**, Flutter |
| Nguồn nhạc | User **chọn thư mục** qua UI; quét **đệ quy** subfolder |
| Định dạng | MP3, M4A/AAC, FLAC, OGG, WAV |
| Cập nhật list | Chỉ khi user bấm **Refresh**; xóa file trên disk → **ẩn/xóa** khỏi app |
| Lưu trữ app | **SQLite** (metadata, playlist, favorite, lịch sử, tên tùy chỉnh) |
| Player | Nền + notification + khóa màn hình; repeat 1 bài / cả playlist; next/prev; seek; tốc độ; **resume** |
| Thư viện | Playlist trong app, **Favorites**, **Lịch sử** |
| UI | Hybrid minimal + cinematic player; **VI + EN**; theme **Dark + Light**; dynamic color Player |
| Sau v1 | Lyrics; export/import backup (có trong spec) |

---

## 1. Phạm vi

- **Thiết bị:** Chỉ máy của bạn (không ưu tiên đa máy / Play Store lúc này).
- **Nền tảng:** Chỉ Android.

---

## 2. Thư mục & quét file

- **Chọn folder:** Có màn hình / luồng UI để user **bấm chọn thư mục** (SAF — chọn một lần, đổi lại trong Cài đặt).
- **Subfolder:** Quét **đệ quy** toàn bộ thư mục con.
- **Định dạng:** MP3, M4A/AAC, FLAC, OGG, WAV.
- **Refresh:** **Không** tự quét; chỉ khi bấm nút **Làm mới / Quét lại**.
- **File xóa trên máy:** Danh sách **đồng bộ** — bài không còn trong folder thì không còn trong app (sau refresh).

---

## 3. Database (SQLite)

Dùng DB vì thư viện lớn + playlist + lịch sử + dữ liệu app-side.

**Lưu trong DB (gợi ý schema sau):**

- Đường dẫn file, thông tin quét lần cuối
- Tag cache: title, artist, album, duration, art path/hash
- **Tên hiển thị tùy chỉnh** khi file không có tag (user điền tay)
- Playlist + bài trong playlist (thứ tự)
- Favorites
- Lịch sử nghe (bài, thời điểm, có thể vị trí)
- Cấu hình: folder URI đã chọn, theme, ngôn ngữ, sort mặc định

**Luồng quét:** Refresh → đọc filesystem → merge vào DB (thêm mới, cập nhật, đánh dấu/xóa mất).

---

## 4. Metadata & danh sách

**Hiển thị:**

- Tên file
- Title / Artist từ **ID3** (hoặc tag tương đương)
- **Ảnh bìa** nhúng trong file

**Không có tag:**

- User **có thể điền tên** (lưu DB); **vẫn phát** được khi chưa điền — badge "Chưa có tên" trên list.

**Sắp xếp:** User **chọn** trong app (nhiều kiểu: tên, artist, thêm mới, …).

**Tìm kiếm:** Có — theo **tên / artist** (gồm cả tên tùy chỉnh đã lưu).

---

## 5. Player

| Tính năng | v1 |
|-----------|-----|
| Phát nền | Có |
| Notification + điều khiển | Có |
| Màn hình khóa | Có |
| Repeat 1 bài / cả playlist | Có |
| Shuffle | *Chưa trả lời* |
| Next / Previous | Có (theo danh sách đang hiển thị) |
| Play / Pause | Có |
| Seek | Có |
| Volume | *Chưa chốt: trong app vs chỉ volume hệ thống* |
| Tốc độ phát (0.75x, 1.25x, …) | Có |
| Sleep timer | *Chưa trả lời* |
| Queue (hàng chờ) | *Chưa trả lời* |
| Resume khi mở lại app | Có (bài + vị trí) |

**Stack kỹ thuật gợi ý:** `just_audio` + `audio_service` + SQLite.

---

## 6. Playlist & thư viện

- **Playlist:** User tạo trong app; **không** đổi file trên disk.
- **Favorites:** Có.
- **Lịch sử nghe gần đây:** Có.

---

## 7. Giao diện

**Phong cách:** **Hybrid** — Library/Settings **minimal**; Player **cinematic** (gradient full màn từ artwork).

**Màn hình v1:**

1. Danh sách bài (có search, sort, refresh)
2. Player (gradient + dynamic color từ ảnh bìa)
3. Cài đặt (folder, Dark/Light, ngôn ngữ, …)
4. **Mini player bar** — **tap** mở Player (transition mượt, không swipe-up v1)

**Ngôn ngữ:** Tiếng Việt + Tiếng Anh.

**Theme v1:** chỉ **Dark** (mặc định) + **Light**. (Preset đỏ/xanh/tím/… đã bỏ khỏi v1.)

**UI đã chốt (2026-05-23):** xem [`docs.md`](../docs.md) §5.1 · Chi tiết: **[`lib/core/theme/DESIGN_SYSTEM.md`](../lib/core/theme/DESIGN_SYSTEM.md)**

---

## 8. Ưu tiên phát triển (cao → thấp)

1. Dễ **bảo trì** code
2. **Ổn định**, ít lỗi
3. **Phát nền** chuẩn
4. Giao diện **đẹp**
5. Làm **nhanh**, dùng được sớm

---

## 9. Để sau / phụ

| Hạng mục | Giai đoạn |
|----------|-----------|
| Lyrics | Sau |
| Export / import backup (playlist, favorite, folder, DB app) | Có trong yêu cầu — có thể v1.1 |

---

## 10. Tính năng v1 — checklist đã chốt

| # | Tính năng | v1 |
|---|-----------|-----|
| 1 | Chọn / đổi thư mục (UI) | B |
| 2 | Quét đệ quy + refresh thủ công | B |
| 3 | SQLite index + đồng bộ xóa file | B |
| 4 | ID3 + ảnh bìa + tên tùy chỉnh khi thiếu tag | B |
| 5 | Search, sort do user chọn | B |
| 6 | Play, seek, speed, repeat, next/prev | B |
| 7 | Phát nền + notification + lock screen | B |
| 8 | Resume | B |
| 9 | Playlist / Favorite / Lịch sử | B |
| 10 | Mini player + 3 màn + settings | B |
| 11 | VI / EN + Dark/Light + dynamic Player | B |
| 12 | Lyrics | S |
| 13 | Backup export/import | N → có thể v1.1 |

---

## Câu hỏi còn mở (trả lời thêm khi rảnh)

Ghi vào `traloi.md` hoặc reply chat:

1. **Shuffle** ngẫu nhiên có cần không?
2. **Volume** — chỉ nút volume máy, hay slider trong app?
3. **Queue** (thêm nhiều bài vào hàng chờ) có cần v1 không?
4. **Sleep timer** có cần không?
5. **Ước lượng số bài** (~100 / ~1000 / ~10000) để chọn chiến lược quét DB?
6. ~~Thiếu tag — chặn phát?~~ → **Đã chốt: vẫn phát + badge** (xem `docs.md` §9)
7. **Mục tiêu 1–2 câu** (mục 1.1 trong `THIET_KE.md`) — tùy chọn.

---

## Kiến trúc module gợi ý (khi code)

```text
lib/
  core/          # theme, locale, constants
  data/          # sqlite, scan service, repositories
  domain/        # models, use cases (tùy độ phức tạp)
  features/
    library/     # list, search, refresh
    player/      # player UI + audio handler
    playlists/
    settings/
```

Pattern: **MVVM** + repository; audio tách `AudioHandler` riêng cho `audio_service`.

---

*File gốc câu trả lời: [`traloi.md`](traloi.md) · Câu hỏi đầy đủ: [`THIET_KE.md`](THIET_KE.md)*

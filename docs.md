# Local Music Player — Tài liệu tổng hợp

> App nghe nhạc **cá nhân**, nhạc **local** trên Android (Flutter).  
> Bạn tải file → bỏ vào **một thư mục** trên máy → app đọc và phát từ thư mục đó.

**Cập nhật:** 2026-05-30 · **UI:** hybrid minimal/cinematic, 2 theme, dynamic color Player

**Tiến độ code:** ✅ **M0 xong** · M1–M4 chưa bắt đầu. Chi tiết checkbox → `lib/**/*.md`.

---

## Mục lục

1. [Tổng quan](#1-tổng-quan)
2. [Phạm vi & mục tiêu](#2-phạm-vi--mục-tiêu)
3. [Danh sách tính năng (theo nhóm)](#3-danh-sách-tính-năng-theo-nhóm)
4. [Màn hình & điều hướng](#4-màn-hình--điều-hướng)
5. [Giao diện & trải nghiệm](#5-giao-diện--trải-nghiệm)
6. [Dữ liệu & lưu trữ](#6-dữ-liệu--lưu-trữ)
7. [Lộ trình phát triển](#7-lộ-trình-phát-triển)
8. [Công nghệ](#8-công-nghệ)
9. [Tính năng chưa chốt](#9-tính-năng-chưa-chốt)
10. [Tài liệu chi tiết khác](#10-tài-liệu-chi-tiết-khác)

---

## 1. Tổng quan

| Hạng mục | Mô tả |
|----------|--------|
| **Tên dự án** | Local Music Player |
| **Nền tảng** | Android (Flutter) |
| **Đối tượng** | Dùng trên **điện thoại cá nhân** của bạn |
| **Nguồn nhạc** | File trên storage, **không** streaming / server |
| **Cách dùng** | Chọn thư mục nhạc → bấm **Refresh** khi có file mới → nghe |

**Không nằm trong phạm vi hiện tại:** đăng nhập, cloud sync, mua nhạc, chia sẻ mạng xã hội, đa nền tảng iOS (có thể sau).

---

## 2. Phạm vi & mục tiêu

### 2.1 Mục tiêu sản phẩm

- Nghe nhạc **offline** từ thư mục bạn tự quản lý.
- Thư viện **ổn định** (SQLite), tìm kiếm / sắp xếp / playlist / yêu thích.
- Phát **nền** với notification và điều khiển màn hình khóa.
- Giao diện **hybrid**: thư viện minimal, player cinematic; **Dark/Light**; hỗ trợ **Tiếng Việt + English**.

### 2.2 Nguyên tắc kỹ thuật (ưu tiên)

1. Dễ **bảo trì** code  
2. **Ổn định**, ít lỗi  
3. **Phát nền** chuẩn  
4. Giao diện **đẹp**  
5. Ra bản **dùng được sớm**

---

## 3. Danh sách tính năng (theo nhóm)

Ký hiệu trạng thái triển khai: ✅ xong · 🔶 một phần · ⏳ chưa làm · ❓ chưa chốt thiết kế

### 3.1 Thư mục & quét thư viện

| # | Tính năng | Trạng thái | Mô tả |
|---|-----------|------------|--------|
| 1 | Chọn thư mục nhạc | ✅ | UI chọn folder (Android SAF), lưu quyền đọc lâu dài |
| 2 | Đổi thư mục | 🔶 | M0: nút trên **Library** AppBar (chưa màn Settings) |
| 3 | Onboarding lần đầu | ✅ | Hướng dẫn chọn folder khi chưa cấu hình |
| 4 | Quét đệ quy subfolder | ✅ | Đọc mọi thư mục con trong folder gốc |
| 5 | Định dạng hỗ trợ | ✅ | MP3, M4A/AAC, FLAC, OGG, WAV |
| 6 | Refresh thủ công | ✅ | **Chỉ** quét khi user bấm nút Làm mới — không tự quét nền |
| 7 | Đồng bộ file xóa | 🔶 | M0: mất khỏi list sau refresh (cache RAM, chưa SQLite) |
| 8 | Quét nền / tự động realtime | ⏳ | Không có trong v1 |

### 3.2 Metadata & danh sách bài

| # | Tính năng | Trạng thái | Mô tả |
|---|-----------|------------|--------|
| 9 | Index SQLite | ⏳ | M1 — hiện cache trong `LibraryRepository` |
| 10 | Đọc tag ID3 | ⏳ | M1 |
| 11 | Ảnh bìa nhúng | ⏳ | M1 |
| 12 | Hiển thị tên file | ✅ | M0: list theo `fileName` |
| 13 | Tên tùy chỉnh (thiếu tag) | ⏳ | M1 |
| 14 | Tìm kiếm | ⏳ | M1 |
| 15 | Sắp xếp | ⏳ | M1 |
| 16 | Thiếu tag — vẫn phát + badge | 🔶 | M0: **vẫn phát**; badge + track_edit chưa làm |

### 3.3 Trình phát nhạc (Player)

| # | Tính năng | Trạng thái | Mô tả |
|---|-----------|------------|--------|
| 17 | Play / Pause | ✅ | M0: `just_audio`, path + SAF |
| 18 | Seek (thanh tua) | ⏳ | M2 |
| 19 | Next / Previous | ⏳ | M2 |
| 20 | Repeat một bài | ⏳ | M2 |
| 21 | Repeat cả playlist / ngữ cảnh | ⏳ | M2 |
| 22 | Tốc độ phát | ⏳ | M2 |
| 23 | Phát nền | ⏳ | M2 |
| 24 | Notification điều khiển | ⏳ | M2 |
| 25 | Điều khiển màn hình khóa | ⏳ | M2 |
| 26 | Resume | ⏳ | M2 |
| 27 | Mini player bar | 🔶 | Widget placeholder; chưa nối shell |
| 28 | Màn player đầy đủ | 🔶 | File placeholder `Player — TODO M2` |
| 29 | Shuffle | ❓ | Chưa chốt |
| 30 | Queue (hàng chờ) | ❓ | Chưa chốt |
| 31 | Volume slider trong app | ❓ | Chưa chốt (có thể chỉ dùng nút volume máy) |
| 32 | Sleep timer | ❓ | Chưa chốt |

### 3.4 Thư viện cá nhân

| # | Tính năng | Trạng thái | Mô tả |
|---|-----------|------------|--------|
| 33 | Playlist tùy chỉnh | ⏳ | M3 — placeholder screen |
| 34 | Thứ tự bài trong playlist | ⏳ | M3 |
| 35 | Phát cả playlist | ⏳ | M3 |
| 36 | Yêu thích (Favorites) | ⏳ | M3 — placeholder screen |
| 37 | Lịch sử nghe | ⏳ | M3 — placeholder screen |
| 38 | Kéo thả sắp xế playlist | 🔶 | Tùy chọn v1, có thể đơn giản hóa |

### 3.5 Cài đặt & hệ thống

| # | Tính năng | Trạng thái | Mô tả |
|---|-----------|------------|--------|
| 39 | Cài đặt thư mục | 🔶 | M0: đổi folder trên Library; màn Settings chưa làm |
| 40 | Theme Dark / Light | 🔶 | M0: dark mặc định; chưa chọn trong Settings |
| 41 | Dynamic color (Player) | ⏳ | M2 |
| 42 | Player Layout A | ⏳ | M2 |
| 43 | Mở Player từ mini bar | ⏳ | M2 |
| 44 | Ngôn ngữ VI / EN | ⏳ | M3 |
| 45 | Export backup | 🔶 | Playlist, favorite, settings — không copy file nhạc |
| 46 | Import backup | 🔶 | v1.1 |
| 47 | Lyrics (lời bài) | ⏳ | Sau v1 |

---

## 4. Màn hình & điều hướng

### 4.1 Màn hình chính (v1)

| Màn hình | Chức năng chính |
|----------|-----------------|
| **Onboarding** | Chọn thư mục nhạc lần đầu |
| **Thư viện (Library)** | Danh sách bài, search, sort, refresh |
| **Player (full)** | Đang phát: art, seek, repeat, speed, next/prev |
| **Playlist** | Danh sách & chi tiết playlist |
| **Lịch sử** | Bài nghe gần đây |
| **Cài đặt** | Folder, theme, ngôn ngữ, backup (sau) |
| **Sửa thông tin bài** | Điền tên khi thiếu tag |
| **Shell (khung app)** | Bottom nav + **mini player** |

### 4.2 Luồng người dùng (tóm tắt)

```text
Mở app
  → AppStartup
  → Chưa có folder? → Onboarding → chọn folder
  → LibraryScreen (M0 — chưa qua ShellScreen)
       → Refresh → thấy bài mới
       → Tap bài → phát/pause (mini bar + Player full: M2)
       → Playlist / Favorite / History / Settings (M3)
```

---

## 5. Giao diện & trải nghiệm

### 5.1 Quyết định UI (đã chốt 2026-05-23)

| # | Chủ đề | Quyết định |
|---|--------|------------|
| 1 | Phong cách | **Hybrid:** Library / Settings **minimal** · Player **cinematic** |
| 2 | Dynamic color | **Có** — chỉ màn Player, từ artwork (`palette_generator`) |
| 3 | Theme | **2 preset:** **Dark** (mặc định) + **Light** — bỏ 4 preset màu (đỏ/xanh/…) khỏi v1 |
| 4 | Layout Player | **Layout A** — gradient + art vuông ~85% width (§6.2 DESIGN_SYSTEM) |
| 5 | Mở Player | **Tap** mini bar → Player full, transition **~250ms** — **không** swipe-up v1 |

### 5.2 Tham chiếu kỹ thuật

| Hạng mục | Quyết định |
|----------|------------|
| Font | **Inter** (Google Fonts) |
| Design system | **[lib/core/theme/DESIGN_SYSTEM.md](lib/core/theme/DESIGN_SYSTEM.md)** |
| Touch | ≥ 48dp |
| Đa ngôn ngữ | Tiếng Việt + English |

**Vùng minimal:** list 48×48 art, AppBar phẳng, nav không pill indicator.  
**Vùng cinematic:** player title 34/w700, gradient nền, seek trên scrim.

---

## 6. Dữ liệu & lưu trữ

### 6.1 Trên máy (filesystem)

- User copy nhạc vào **một folder** đã chọn.
- App **không** copy nhạc vào bộ nhớ riêng app (trừ cache ảnh bìa).

### 6.2 Trong app (SQLite)

| Dữ liệu | Ghi chú |
|---------|---------|
| Tracks | path/URI, tag, art cache, **dominant_color** (player gradient), custom title, missing_tags |
| Playlists + bài + thứ tự | Chỉ trong app |
| Favorites | |
| Play history | |
| Settings | folder URI, theme, locale, repeat, speed |
| Playback state | Resume bài + position |

### 6.3 Quy tắc đồng bộ

- **Refresh** = đọc folder → merge DB (thêm / cập nhật / xóa bài mất).
- Metadata đọc lại khi file đổi (modified time).

---

## 7. Lộ trình phát triển

| Phase | Mục tiêu | Tính năng chính | Tiến độ |
|-------|----------|-----------------|---------|
| **M0** | Dùng thử được | Chọn folder, refresh, list file, phát/pause cơ bản | ✅ |
| **M1** | Thư viện đủ | SQLite, ID3, art, search/sort, sửa tên thiếu tag | ⏳ |
| **M2** | Nghe hàng ngày | Phát nền, notification, mini bar, seek, speed, repeat, resume | ⏳ |
| **M3** | Full v1 | Playlist, favorite, history, settings, Dark/Light theme, VI/EN | ⏳ |
| **M4** | v1.1 | Backup export/import, lyrics (nếu làm) | ⏳ |

**Thứ tự code:** xem **[lib/README.md](lib/README.md)** — bắt đầu M0 từ `onboarding` → `folder_access` → `library` → `audio`.

---

## 8. Công nghệ

| Thành phần | Công nghệ |
|------------|-----------|
| Framework | Flutter (Dart) |
| DB | SQLite (`sqflite`) |
| Folder Android | SAF / file picker |
| Metadata | Plugin đọc ID3 (vd. `flutter_media_metadata`) |
| Phát nhạc | `just_audio` |
| Phát nền | `audio_service` |
| State / DI | Riverpod hoặc Provider + `get_it` (tùy implement) |
| i18n | `flutter_localizations` + ARB |
| Font | `google_fonts` (Inter) |
| Màu từ artwork | `palette_generator` (Player) |

**Kiến trúc:** MVVM + Repository · một `AudioHandler` cho toàn app.

---

## 9. Tính năng chưa chốt

| # | Câu hỏi | Trạng thái |
|---|---------|------------|
| 1 | Có **Shuffle** không? | ❓ |
| 2 | **Volume** — slider trong app hay chỉ phím volume máy? | ❓ |
| 3 | Có **Queue** trong v1 không? | ❓ |
| 4 | Có **Sleep timer** không? | ❓ |
| 5 | Thiếu tag — chặn phát hay vẫn phát? | ✅ **Vẫn phát** + badge "Chưa có tên" (§3.2 #16) |
| 6 | Ước lượng **số bài** để tối ưu quét? | ❓ |

Ghi thêm câu trả lời vào `pttkht/traloi.md` hoặc cập nhật mục này.

---

## 10. Tài liệu chi tiết khác

| File | Nội dung |
|------|----------|
| **[docs.md](docs.md)** | **Tài liệu tổng hợp này** — toàn bộ tính năng |
| [pttkht/Thiết kế hệ thống.md](pttkht/Thiết%20kế%20hệ%20thống.md) | Quyết định chức năng & checklist v1 |
| [pttkht/KIEN_TRUC.md](pttkht/KIEN_TRUC.md) | Kiến trúc kỹ thuật, schema DB, luồng |
| [lib/README.md](lib/README.md) | Cây code & thứ tự làm từng folder |
| [lib/core/theme/DESIGN_SYSTEM.md](lib/core/theme/DESIGN_SYSTEM.md) | UI: màu, font, component |
| `pttkht/THIET_KE.md` | Câu hỏi thiết kế ban đầu |
| `lib/features/<tên>/<tên>.md` | **Checklist chi tiết** — tick `[x]` khi xong từng việc nhỏ |

### Cách đánh dấu tiến độ

1. **Hàng ngày:** sửa checkbox trong `lib/**/<tên>.md` của module vừa code (`[ ]` → `[x]`).
2. **Xong cả nhóm tính năng:** cập nhật cột **Trạng thái** ở §3 file này (`docs.md`).
3. **Xong cả phase:** cập nhật cột **Tiến độ** ở §7 và bảng tóm tắt bên dưới.

Chỉ tick `[x]` khi **chạy được trên máy**, không chỉ viết code.

---

## Bảng tóm tắt nhanh — tiến độ thực tế (2026-05-30)

```text
✅ Chọn folder (SAF)     ✅ Refresh thủ công      ✅ Quét subfolder
✅ Hiển thị tên file    ✅ Play / Pause (M0)     🔶 Đổi folder (Library AppBar)
⏳ SQLite + ID3 + art    ⏳ Search & sort         ⏳ Custom tên thiếu tag
⏳ Seek / speed / repeat ⏳ Next / prev            ⏳ Phát nền + notification
⏳ Resume                ⏳ Mini player (shell)   ⏳ Player cinematic
⏳ Playlist / Favorite / History / Settings      🔶 Backup (placeholder)  ⏳ Lyrics
❓ Shuffle · Queue · Volume app · Sleep timer
```

---

*Khi thêm/bớt tính năng: cập nhật checklist `lib/**/*.md` trước, rồi đồng bộ `docs.md` §3 và §7.*

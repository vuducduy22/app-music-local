# Design System — Local Music Player

> **File chuẩn duy nhất** cho màu, chữ, khoảng cách và component. Mọi màn hình trong `features/*` **bám theo đây**, không tự chọn màu/font riêng.

**Liên quan:** `app_theme.dart`, `app_theme_data.dart` · **Quyết định UI:** 2026-05-23 (xem §1.1)

---

## 1. Nguyên tắc

| Nguyên tắc | Ý nghĩa |
|------------|---------|
| **Hybrid** | **Library / Settings / Playlist** = minimal · **Player** = cinematic |
| **Nhất quán** | Cùng token → cùng widget; không hard-code `Color(0x...)` trong feature |
| **Nhạc là trung tâm** | Player: artwork + gradient full màn; list: art nhỏ, chrome lặng |
| **Một tay** | Nút ≥ 48dp; mini player dễ bấm |
| **Đọc được** | Contrast chữ ≥ WCAG AA (kể cả chữ trên gradient — dùng scrim) |

### 1.1 Quyết định UI đã chốt (2026-05-23)

| # | Chủ đề | Quyết định |
|---|--------|------------|
| 1 | Phong cách | **Hybrid:** Library minimal + Player cinematic |
| 2 | Dynamic color | **Có**, chỉ ở **Player** (từ artwork) |
| 3 | Theme preset | **2:** Dark (mặc định) + Light — không dùng 4 preset màu cũ trong v1 |
| 4 | Layout Player | **Layout A** — gradient + art vuông 85% width |
| 5 | Mở Player | **Tap** mini bar / điều hướng — **không** swipe-up v1; transition **mượt** (`normal` 250ms) |

---

## 2. Hai chế độ giao diện

### 2.1 Minimal (Library, Playlist, History, Settings, Onboarding)

- Nền `surface` phẳng, **không** gradient.
- Ít màu accent; primary chỉ nút/icon active, seek không áp dụng ở đây.
- List tile 48×48 art, typography chuẩn §3.

### 2.2 Cinematic (Player full screen)

- **Layout A:** gradient full màn + artwork vuông ~85% width phía trên (§6.2) — **không** blur nền.
- **Scrim tối** phía dưới cho chữ/seek.
- Accent (progress, play) = tương phản trên gradient (thường `#FAFAFA`).

**Không** áp dụng gradient/dynamic color lên Library hay Settings.

---

## 3. Design tokens

Dùng **`Theme.of(context).colorScheme`** + **`Theme.of(context).textTheme`**; mở rộng qua `ThemeExtension<AppThemeTokens>`.

```text
AppSpacing      xs sm md lg xl
AppRadius       sm md lg full
AppDuration     fast normal slow
AppElevation    none low mid high
AppOpacity      disabled (38%) · hint (60%) · subtle (12%)
AppScrim        dark (black54) · light (white24) — chữ trên art/gradient
```

---

## 4. Phông chữ (Typography)

### 4.1 Font family

| Vai trò | Font | Ghi chú |
|---------|------|---------|
| **Chính (UI)** | **Inter** | `google_fonts` — tiếng Việt |
| **Số / thời lượng** | Inter + `FontFeature.tabularFigures()` | Seek, duration |
| **Fallback** | System sans | |

### 4.2 Thang chữ

| Token | Size | Weight | Dùng cho |
|-------|------|--------|----------|
| `displayMedium` | **34** | **w700** | **Tên bài — Player full** |
| `displaySmall` | 28 | w600 | Tiêu đề phụ (ít dùng) |
| `titleLarge` | 20 | w600 | App bar |
| `titleMedium` | 16 | w600 | Tên bài trong list |
| `titleSmall` | 14 | w600 | Section header |
| `bodyLarge` | 16 | **w500** | **Artist — Player** (opacity 70% trên gradient) |
| `bodyMedium` | 14 | w400 | Artist list |
| `bodySmall` | 12 | w400 | Thời gian, hint |
| `labelLarge` | 14 | w500 | Nút, tab |
| `labelMedium` | 12 | w500 | Badge |

**Ellipsis:** list / mini bar 1 dòng; player title tối đa **2 dòng**.

---

## 5. Màu — Hai preset app (v1)

User chọn **Dark** hoặc **Light** trong Settings. **Mặc định: Dark.**

Preset red / blue / green / purple **không** có trong v1 (có thể v1.1 nếu cần).

### 5.1 Dark (`AppThemeKey.dark`) — mặc định

| Role | Hex |
|------|-----|
| primary | `#FAFAFA` |
| onPrimary | `#0A0A0A` |
| secondary | `#B0B0B0` |
| surface | `#0A0A0A` |
| surfaceContainerHighest | `#1A1A1A` |
| onSurface | `#F5F5F5` |
| onSurfaceVariant | `#B0B0B0` |
| outline | `#2A2A2A` |
| **error** | `#EF5350` |
| onError | `#FFFFFF` |

OLED-friendly; surface sâu hơn `#121212` cũ. `error` dùng snackbar, form, lỗi quét folder.

### 5.2 Light (`AppThemeKey.light`)

| Role | Hex |
|------|-----|
| primary | `#1A1A1A` |
| onPrimary | `#FFFFFF` |
| secondary | `#616161` |
| surface | `#FFFFFF` |
| surfaceContainerHighest | `#F5F5F5` |
| onSurface | `#1A1A1A` |
| onSurfaceVariant | `#616161` |
| outline | `#E0E0E0` |
| **error** | `#C62828` |
| onError | `#FFFFFF` |

### 5.3 Chế độ sáng / tối (`theme_mode`)

**Schema từ đầu:** enum **3 giá trị** — tránh đổi DB sau.

| `AppThemeMode` | `MaterialApp.themeMode` | UI Settings v1 |
|----------------|---------------------------|----------------|
| `dark` | `ThemeMode.dark` | Có — **mặc định** |
| `light` | `ThemeMode.light` | Có |
| `system` | `ThemeMode.system` | Ẩn v1 — bật option sau không đổi schema |

`theme_key` trong DB = `dark` \| `light` (bảng màu §5.1–5.2). Khi `theme_mode == system`, Flutter map theo OS; `theme_key` vẫn là palette dark hoặc light user đã chọn (mặc định dark).

---

## 6. Dynamic color (chỉ Player)

### 6.1 Công nghệ

- Package: **`palette_generator`** (Flutter team).
- Input: file art cache hoặc bytes artwork bài đang phát.
- Output: `dominantColor`, `vibrantColor` (optional) → gradient + tint seek.

### 6.2 UI — Layout Player (**Layout A** — đã chốt)

**Chọn Layout A** (gradient nền + artwork vuông ~85% width giữa phía trên — kiểu Apple Music). **Không** dùng blur full màn (Layout B) hay art tròn nhỏ (Layout C) trong v1.

```text
Lớp 1 (back):  Gradient full màn dominantColor → surface (§6.4 nếu không art)
Lớp 2:         Artwork vuông ~85% screen width, radiusXl 20, center-upper
Lớp 3:         Scrim bottom ~40% chiều cao (đen opacity tăng dần)
Lớp 4 (front): Title, seek, controls trong vùng scrim
```

- **Không** blur artwork làm nền (tránh lag máy yếu).
- **Mini player:** nền `surfaceContainerHighest` (minimal); viền trái 3dp tint `dominantColor` (tùy chọn M2).

### 6.3 Cache

- Lưu `dominant_color` (int ARGB) trong bảng `tracks` khi extract metadata — tránh tính lại mỗi lần mở player.
- Đổi artwork → tính lại khi refresh metadata.

### 6.4 Fallback (không artwork / chưa extract)

**Không** dùng `surface` → `surfaceContainerHighest` thuần (trên dark gần như không thấy — trông “broken”).

**Gradient cố định “no artwork”** (v1):

| Theme | Gradient (top → bottom) |
|-------|-------------------------|
| Dark | `#4A148C` (violet đậm) → `#0A0A0A` |
| Light | `#7E57C2` @ 40% → `#F5F5F5` |

Placeholder giữa màn: icon `music_note` lớn `onSurfaceVariant` @ 38% trong khung vuông 85% width (cùng vị trí Layout A).

Có art nhưng `palette_generator` lỗi: fallback = `primary` @ **20%** opacity → `surface` (vẫn thấy chuyển màu).

---

## 7. Khoảng cách & lưới (Spacing)

Base unit: **4dp**.

| Token | dp | Dùng |
|-------|-----|------|
| `xs` | 4 | Icon + chữ |
| `sm` | 8 | List item dọc |
| `md` | 16 | Padding màn ngang |
| `lg` | 24 | Section |
| `xl` | 32 | Player controls |

**List tile:** min height **72**, art **48×48**.

---

## 8. Bo góc, viền, đổ bóng

| Token | Value | Dùng |
|-------|-------|------|
| `radiusSm` | 8 | Chip, search |
| `radiusMd` | 12 | List art |
| `radiusLg` | 16 | Sheet |
| `radiusXl` | **20** | Artwork thumbnail trên player (nếu hiển thị khung) |
| `radiusFull` | 999 | Nút play |

| Elevation | dp | Dùng |
|-----------|-----|------|
| none | 0 | List, **mini player dark** |
| low | 1 | Card list (light theme) |
| mid | 3 | Mini player **light** only |
| high | 6 | Modal |

**Mini player dark:** **không shadow** — `border-top` 1dp `outline` @ 20% opacity.

**Divider:** `outline` 1dp, inset 16dp sau avatar.

---

## 9. Icon

Material Outlined · 24 (chrome) · 32 (player phụ) · 48 (play chính).

Màu trên Player gradient: **`onPrimary` / trắng** với scrim; list dùng `onSurface` / `primary`.

---

## 10. Component — Spec

### 10.1 AppBar (minimal zones)

- Nền `surface`, không gradient.
- `titleLarge`, icon 24.

### 10.2 NavigationBar (Shell)

- Nền `surface` hoặc `surfaceContainerHighest`.
- **`indicatorColor: Colors.transparent`** — không pill Material.
- Selected: icon **filled** + `primary`; unselected: outline + `onSurfaceVariant`.

### 10.3 List tile

Giống trước: 48 art, `titleMedium` + `bodyMedium`, ripple primary 8%.

### 10.4 Nút (minimal zones)

`FilledButton` / `OutlinedButton` / `IconButton` ≥ 48dp.

### 10.5 Mini player bar

- Height **64** + safe area.
- **Tap anywhere** (trừ nút play) → `PlayerScreen` với **`PageRouteBuilder` / shared axis** duration **normal (250ms)**.
- **Không** swipe-up gesture v1.
- Dark: border-top §8; Light: elevation low.

### 10.6 Player screen (cinematic — **Layout A**)

Xem §6.2. Tóm tắt stack:

```text
[ Gradient full màn — dominantColor hoặc §6.4 no-art ]
[ Artwork vuông ~85% width, radiusXl, center-upper — KHÔNG blur nền ]
[ Scrim bottom ~40% ]
[ Title displayMedium 34/w700 — 2 lines ]
[ Artist bodyLarge w500 @ 70% ]
[ Seek + times + prev / play 64 / next + repeat / speed ]
```

- Không AppBar solid — nút down trên gradient (safe area).
- Controls trong vùng scrim.

### 10.7 Settings / Empty / Loading

Giữ minimal; empty icon `onSurfaceVariant` @ 38%.

---

## 11. Chuyển động (Motion)

| Token | ms | Dùng |
|-------|-----|------|
| fast | 150 | Icon toggle |
| **normal** | **250** | **Mở Player từ mini bar**, đổi tab |
| slow | 350 | (dự phòng) |

Curve: `Curves.easeInOut`. **Không** swipe-up sheet v1.

---

## 12. Hình ảnh & artwork

| Ngữ cảnh | Quy cách |
|----------|----------|
| List | 48×48, `radiusMd`, crop |
| Player | Nguồn gradient; art lớn ~**85%** `MediaQuery.sizeOf(context).width` max ~340dp |
| Placeholder | `surfaceContainerHighest` + `music_note` |
| Cache | File local + `dominant_color` trong DB |

---

## 13. Map sang Flutter

### 13.1 File

| File | Nội dung |
|------|----------|
| `app_theme.dart` | `enum AppThemeKey { dark, light }` |
| `app_theme_data.dart` | `ThemeData` §5 |
| `app_colors.dart` | Hex maps |
| `player_gradient.dart` | Gradient từ dominant + scrim |
| `artwork_palette_service.dart` | `palette_generator` + cache |

### 13.2 Dependencies

```yaml
google_fonts:
palette_generator:
```

### 13.3 Quy tắc

```dart
// ✅
Theme.of(context).colorScheme.primary

// ❌ trong features/
Colors.red
```

### 13.4 `MaterialApp`

```dart
theme: buildAppTheme(AppThemeKey.light),
darkTheme: buildAppTheme(AppThemeKey.dark),
themeMode: mapThemeMode(settings.themeMode), // AppThemeMode: dark | light | system
```

---

## 14. Checklist trước khi merge UI

- [ ] Library/Settings **không** dùng gradient dynamic
- [ ] Player có gradient + dynamic color + scrim chữ
- [ ] Chỉ test **2 theme** dark + light
- [ ] Mini → Player: **tap** + transition 250ms
- [ ] Mini dark: border-top, không shadow
- [ ] Nav: transparent indicator
- [ ] Touch ≥ 48dp

---

*Cập nhật 2026-05-23 theo quyết định UI · Sửa visual **ở đây trước** rồi mới sửa widget.*

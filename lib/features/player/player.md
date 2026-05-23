# player — Màn phát nhạc & mini bar

## Mục đích

- **Mini player bar**: minimal chrome trên shell
- **Player screen**: **cinematic** — gradient full màn từ artwork, dynamic color

**Design:** [`DESIGN_SYSTEM.md`](../../core/theme/DESIGN_SYSTEM.md) §2.2, §6, §10.6

## Việc cần làm

### Mini bar (`widgets/mini_player_bar.dart`)

- [ ] Listen `AudioController` state
- [ ] **Tap** (không swipe-up v1) → `PlayerScreen` transition **250ms** mượt
- [ ] Play/pause 48dp
- [ ] Dark: border-top; light: elevation low

### Player screen

- [ ] **Layout A:** gradient full màn + art vuông ~85% width (không blur nền)
- [ ] `palette_generator` + cache `dominant_color`; fallback §6.4 DESIGN_SYSTEM
- [ ] Scrim bottom cho title/seek/controls
- [ ] Title **34/w700**, artist 16/w500 @ 70%
- [ ] Seek + thời gian tabular
- [ ] Prev / play 64 / next; repeat; speed
- [ ] Nút back trên gradient (không AppBar solid)

## File

- `player_screen.dart`
- `player_view_model.dart`
- `widgets/mini_player_bar.dart`
- (core) `artwork_palette_service.dart`, `player_gradient.dart`

## Phase

**M2**

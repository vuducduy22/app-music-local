# player — Màn phát nhạc & mini bar

## Mục đích

- **Mini player bar**: minimal chrome trên shell
- **Player screen**: **cinematic** — gradient full màn từ artwork, dynamic color

**Design:** [`DESIGN_SYSTEM.md`](../../core/theme/DESIGN_SYSTEM.md) §2.2, §6, §10.6

## Việc cần làm

### Mini bar (`widgets/mini_player_bar.dart`)

- [x] Listen `AudioController` state
- [x] **Tap** → `PlayerScreen` transition **250ms**
- [x] Play/pause 48dp
- [x] Dark: border-top; light: elevation low

### Player screen

- [x] **Layout A:** gradient full màn + art vuông ~85% width
- [x] `palette_generator` khi mở player (fallback §6.4)
- [x] Scrim bottom cho title/seek/controls
- [x] Title **34/w700**, artist 16/w500 @ 70%
- [x] Seek + thời gian tabular
- [x] Prev / play 64 / next; repeat; speed
- [x] Nút back trên gradient (không AppBar solid)

## File

- `player_screen.dart`
- `player_view_model.dart`
- `widgets/mini_player_bar.dart`
- (core) `artwork_palette_service.dart`, `player_gradient.dart`

## Phase

**M2**

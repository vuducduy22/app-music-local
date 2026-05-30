# constants — Hằng số toàn app

## Việc cần làm

- [x] `supportedAudioExtensions` — mp3, m4a, aac, flac, ogg, wav
- [ ] Tên bảng / cột DB (nếu không để hết trong DAO)
- [x] Key: `music_folder_path` (`PrefsKeys.musicFolderPath`)
- [x] Key: `library_refresh_hint_pending` — gợi ý Refresh lần đầu
- [ ] Keys khác: `pref_onboarding_done`, theme, locale, …
- [ ] Giới hạn (debounce seek ms, batch scan size)

## File dự kiến

- `app_constants.dart`

# di — Dependency injection

## Việc cần làm

- [x] `AppDependencies.init()` gọi từ `main.dart`
- [x] Register singleton M0: `SettingsRepository`, `FolderAccessService`, `LibraryRepository`, `AudioController`
- [ ] Register singleton: `AppDatabase`, repo M1+, `AudioHandler`
- [ ] Factory: ViewModels (hoặc dùng Riverpod thay `get_it` cho VM)

## File dự kiến

- `injection.dart`

## Phase

M0 (khung) → M1 (đủ repo)

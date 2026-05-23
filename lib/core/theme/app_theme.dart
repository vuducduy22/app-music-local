/// Palette màu app — xem [DESIGN_SYSTEM.md] §5.
enum AppThemeKey {
  /// Mặc định — nền #0A0A0A, OLED-friendly.
  dark,

  /// Nền sáng tối giản.
  light,
}

/// Chế độ sáng/tối — lưu DB từ đầu (3 giá trị). UI Settings v1: dark + light.
enum AppThemeMode {
  dark,
  light,

  /// Theo hệ thống — ẩn UI v1, bật sau không đổi schema.
  system,
}

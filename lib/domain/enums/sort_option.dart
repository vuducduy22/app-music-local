/// Kiểu sắp xếp thư viện — xem [enums.md].
enum SortOption {
  fileName,
  title,
  artist,
  dateAdded,
}

extension SortOptionLabels on SortOption {
  String get label => switch (this) {
        SortOption.fileName => 'Tên file',
        SortOption.title => 'Tên bài',
        SortOption.artist => 'Nghệ sĩ',
        SortOption.dateAdded => 'Mới thêm',
      };
}

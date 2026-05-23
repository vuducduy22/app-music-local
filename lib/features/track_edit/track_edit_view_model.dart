import 'package:flutter/foundation.dart';

/// Logic sửa track — xem [track_edit.md].
class TrackEditViewModel extends ChangeNotifier {
  TrackEditViewModel({required this.trackId});

  final int trackId;

  Future<void> save({required String title, String? artist}) async {
    // TODO(M1): update custom_title / custom_artist in DB
    notifyListeners();
  }
}

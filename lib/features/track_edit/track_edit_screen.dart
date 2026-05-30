import 'package:flutter/material.dart';

import '../../domain/models/track.dart';
import '../library/library_view_model.dart';

/// Sửa tên bài thiếu tag — xem [track_edit.md].
class TrackEditScreen extends StatefulWidget {
  const TrackEditScreen({
    super.key,
    required this.track,
    required this.viewModel,
  });

  final Track track;
  final LibraryViewModel viewModel;

  @override
  State<TrackEditScreen> createState() => _TrackEditScreenState();
}

class _TrackEditScreenState extends State<TrackEditScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _artistController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.track.customTitle ?? widget.track.title ?? '',
    );
    _artistController = TextEditingController(
      text: widget.track.customArtist ?? widget.track.artist ?? '',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên bài')),
      );
      return;
    }

    setState(() => _saving = true);
    final ok = await widget.viewModel.saveCustomMetadata(
      track: widget.track,
      title: title,
      artist: _artistController.text.trim(),
    );
    if (!mounted) return;
    setState(() => _saving = false);

    if (ok) {
      Navigator.pop(context, true);
    } else if (widget.viewModel.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.viewModel.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Điền thông tin bài')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'File: ${widget.track.fileName}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Tên bài *',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _artistController,
              decoration: const InputDecoration(
                labelText: 'Nghệ sĩ',
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving ? 'Đang lưu…' : 'Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}

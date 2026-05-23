import 'package:flutter/material.dart';

import '../../core/di/app_dependencies.dart';
import '../../data/models/scanned_audio_file.dart';
import 'library_view_model.dart';

/// Danh sách nhạc — xem [library.md].
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late final LibraryViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final deps = AppDependencies.instance;
    _viewModel = LibraryViewModel(
      libraryRepository: deps.libraryRepository,
      audioController: deps.audioController,
      settingsRepository: deps.settingsRepository,
      folderAccessService: deps.folderAccessService,
    );
    _viewModel.loadTracks();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final vm = _viewModel;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Thư viện'),
            actions: [
              IconButton(
                onPressed: () => _onChangeFolder(context, vm),
                icon: const Icon(Icons.folder_outlined),
                tooltip: 'Đổi thư mục',
              ),
              if (vm.isRefreshing)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                IconButton(
                  onPressed: vm.refresh,
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Quét lại',
                ),
            ],
          ),
          body: _buildBody(context, vm),
          bottomNavigationBar: vm.isPreparingPlayback
              ? const LinearProgressIndicator()
              : null,
        );
      },
    );
  }

  Future<void> _playTrack(
    BuildContext context,
    LibraryViewModel vm,
    ScannedAudioFile track,
  ) async {
    final ok = await vm.togglePlay(track);
    if (!context.mounted) return;
    if (!ok && vm.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.error!),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  Future<void> _onChangeFolder(
    BuildContext context,
    LibraryViewModel vm,
  ) async {
    final current = await vm.getMusicFolderPath();
    if (!context.mounted) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đổi thư mục nhạc'),
        content: Text(
          current != null
              ? 'Thư mục hiện tại:\n$current\n\nChọn thư mục mới?'
              : 'Chọn thư mục chứa nhạc.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Chọn thư mục'),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) return;

    final ok = await vm.changeMusicFolder();
    if (!context.mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã đổi thư mục và quét lại')),
      );
    } else if (vm.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.error!)),
      );
    }
  }

  Widget _buildBody(BuildContext context, LibraryViewModel vm) {
    if (vm.isLoading && vm.tracks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.error != null && vm.tracks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(vm.error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: vm.refresh,
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (vm.tracks.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Không tìm thấy file nhạc.\n'
            '• Bấm ⟳ để quét lại\n'
            '• Hoặc icon thư mục → chọn lại folder có file .mp3',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: vm.refresh,
      child: ListView.separated(
        itemCount: vm.tracks.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final track = vm.tracks[index];
          final playing = vm.isPlaying(track);
          return ListTile(
            leading: CircleAvatar(
              child: Icon(playing ? Icons.volume_up : Icons.music_note),
            ),
            title: Text(
              track.fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              icon: Icon(playing ? Icons.pause : Icons.play_arrow),
              onPressed: () => _playTrack(context, vm, track),
            ),
            onTap: () => _playTrack(context, vm, track),
          );
        },
      ),
    );
  }
}

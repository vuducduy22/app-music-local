import 'package:flutter/material.dart';

import '../../core/di/app_dependencies.dart';
import '../../core/widgets/track_artwork.dart';
import '../../domain/enums/sort_option.dart';
import '../../domain/models/track.dart';
import '../track_edit/track_edit_screen.dart';
import 'library_view_model.dart';

/// Danh sách nhạc — xem [library.md].
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late final LibraryViewModel _viewModel;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    final deps = AppDependencies.instance;
    _viewModel = LibraryViewModel(
      libraryRepository: deps.libraryRepository,
      audioController: deps.audioController,
      settingsRepository: deps.settingsRepository,
      folderAccessService: deps.folderAccessService,
    );
    _viewModel.loadTracks().then((_) => _maybeShowRefreshHint());
  }

  Future<void> _maybeShowRefreshHint() async {
    final settings = AppDependencies.instance.settingsRepository;
    final showHint = await settings.consumeLibraryRefreshHint();
    if (!showHint || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Đã chọn thư mục. App đang quét nhạc — '
          'bấm ⟳ hoặc kéo xuống để quét lại khi có file mới.',
        ),
        duration: Duration(seconds: 6),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
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
              PopupMenuButton<SortOption>(
                icon: const Icon(Icons.sort),
                tooltip: 'Sắp xếp',
                initialValue: vm.sort,
                onSelected: vm.setSort,
                itemBuilder: (context) => SortOption.values
                    .map(
                      (option) => PopupMenuItem(
                        value: option,
                        child: Text(option.label),
                      ),
                    )
                    .toList(),
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
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: SearchBar(
                  controller: _searchController,
                  hintText: 'Tìm tên bài, nghệ sĩ…',
                  leading: const Icon(Icons.search),
                  onChanged: vm.setQuery,
                  trailing: vm.query.isNotEmpty
                      ? [
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              vm.setQuery('');
                            },
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ),
          body: _buildBody(context, vm),
        );
      },
    );
  }

  Future<void> _playTrack(
    BuildContext context,
    LibraryViewModel vm,
    Track track,
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

  Future<void> _openTrackEdit(LibraryViewModel vm, Track track) async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => TrackEditScreen(
          track: track,
          viewModel: vm,
        ),
      ),
    );
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
            vm.query.isNotEmpty
                ? 'Không có kết quả cho "${vm.query}".'
                : 'Không tìm thấy file nhạc.\n'
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
            leading: TrackArtwork(
              trackSeed: track.fileUri,
              artCachePath: track.artCachePath,
              displayTitle: track.displayTitle,
              playing: playing,
              size: 48,
              borderRadius: 8,
            ),
            title: Text(
              track.displayTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (track.displayArtist.isNotEmpty)
                  Text(
                    track.displayArtist,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                if (track.missingTags)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: ActionChip(
                      label: const Text('Chưa có tên'),
                      visualDensity: VisualDensity.compact,
                      onPressed: () => _openTrackEdit(vm, track),
                    ),
                  ),
              ],
            ),
            isThreeLine: track.missingTags,
            trailing: IconButton(
              icon: Icon(playing ? Icons.pause : Icons.play_arrow),
              onPressed: () => _playTrack(context, vm, track),
            ),
            onTap: () => _playTrack(context, vm, track),
            onLongPress: track.missingTags
                ? () => _openTrackEdit(vm, track)
                : null,
          );
        },
      ),
    );
  }
}

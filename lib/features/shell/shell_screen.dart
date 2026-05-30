import 'dart:io';

import 'package:flutter/material.dart';

import '../../audio/audio_controller.dart';
import '../../core/di/app_dependencies.dart';
import '../../core/theme/artwork_palette_cache.dart';
import '../../domain/models/track.dart';
import '../history/history_screen.dart';
import '../library/library_screen.dart';
import '../playlists/playlists_screen.dart';
import '../player/player_screen.dart';
import '../player/player_view_model.dart';
import '../player/widgets/mini_player_bar.dart';
import '../settings/settings_screen.dart';

/// Khung app — xem [shell.md].
class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _tabIndex = 0;
  late final AudioController _audio;
  late final PlayerViewModel _playerViewModel;
  String? _warmedTrackUri;

  static const _tabs = [
    LibraryScreen(),
    PlaylistsScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _audio = AppDependencies.instance.audioController;
    _playerViewModel = PlayerViewModel(_audio);
    _audio.addListener(_warmPlayerAssets);
    WidgetsBinding.instance.addPostFrameCallback((_) => _warmPlayerAssets());
  }

  @override
  void dispose() {
    _audio.removeListener(_warmPlayerAssets);
    _playerViewModel.dispose();
    super.dispose();
  }

  void _warmPlayerAssets() {
    if (!mounted) return;
    final track = _audio.playbackState.currentTrack;
    final uri = track?.fileUri;
    if (uri == null || uri == _warmedTrackUri) return;
    _warmedTrackUri = uri;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    ArtworkPaletteCache.instance.warmTrack(track, isDark: isDark);

    final artPath = track?.artCachePath;
    if (artPath != null && mounted) {
      precacheImage(FileImage(File(artPath)), context);
    }
  }

  void _openPlayer() {
    if (!_audio.playbackState.hasTrack) return;

    final track = _audio.playbackState.currentTrack;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = ArtworkPaletteCache.instance.gradientFor(
      track?.artCachePath,
      isDark: isDark,
    );

    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 280),
        reverseTransitionDuration: const Duration(milliseconds: 240),
        pageBuilder: (context, animation, secondaryAnimation) {
          return PlayerScreen(
            viewModel: _playerViewModel,
            initialGradient: gradient,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curve = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(curve),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tabIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ReactiveMiniPlayer(
            audio: _audio,
            onOpenPlayer: _openPlayer,
          ),
          NavigationBar(
            selectedIndex: _tabIndex,
            onDestinationSelected: (index) =>
                setState(() => _tabIndex = index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.library_music_outlined),
                selectedIcon: Icon(Icons.library_music),
                label: 'Thư viện',
              ),
              NavigationDestination(
                icon: Icon(Icons.queue_music_outlined),
                selectedIcon: Icon(Icons.queue_music),
                label: 'Playlist',
              ),
              NavigationDestination(
                icon: Icon(Icons.history_outlined),
                selectedIcon: Icon(Icons.history),
                label: 'Lịch sử',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: 'Cài đặt',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Chỉ rebuild mini player khi bài / trạng thái phát đổi — không theo position.
class _ReactiveMiniPlayer extends StatefulWidget {
  const _ReactiveMiniPlayer({
    required this.audio,
    required this.onOpenPlayer,
  });

  final AudioController audio;
  final VoidCallback onOpenPlayer;

  @override
  State<_ReactiveMiniPlayer> createState() => _ReactiveMiniPlayerState();
}

class _ReactiveMiniPlayerState extends State<_ReactiveMiniPlayer> {
  Track? _track;
  bool _playing = false;
  bool _isPreparing = false;

  @override
  void initState() {
    super.initState();
    widget.audio.addListener(_sync);
    _sync();
  }

  @override
  void dispose() {
    widget.audio.removeListener(_sync);
    super.dispose();
  }

  void _sync() {
    final state = widget.audio.playbackState;
    if (state.currentTrack?.fileUri == _track?.fileUri &&
        state.playing == _playing &&
        state.isPreparing == _isPreparing) {
      return;
    }
    setState(() {
      _track = state.currentTrack;
      _playing = state.playing;
      _isPreparing = state.isPreparing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MiniPlayerBar(
      track: _track,
      playing: _playing,
      isPreparing: _isPreparing,
      onTap: widget.onOpenPlayer,
      onPlayPause: widget.audio.togglePlayPause,
    );
  }
}

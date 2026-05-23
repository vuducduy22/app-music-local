import 'package:flutter/material.dart';

import 'onboarding_view_model.dart';

/// Chọn thư mục lần đầu — xem [onboarding.md].
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({
    super.key,
    required this.viewModel,
    required this.onCompleted,
  });

  final OnboardingViewModel viewModel;
  final VoidCallback onCompleted;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Local Music Player')),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Icon(
                  Icons.folder_open,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Chọn thư mục chứa nhạc',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'App sẽ quét đệ quy mọi file MP3, FLAC, … trong thư mục và thư mục con.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                if (viewModel.error != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    viewModel.error!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
                const Spacer(),
                FilledButton.icon(
                  onPressed: viewModel.loading
                      ? null
                      : () async {
                          final ok = await viewModel.pickMusicFolder();
                          if (ok && context.mounted) {
                            onCompleted();
                          }
                        },
                  icon: viewModel.loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.create_new_folder_outlined),
                  label: Text(
                    viewModel.loading ? 'Đang lưu…' : 'Chọn thư mục',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

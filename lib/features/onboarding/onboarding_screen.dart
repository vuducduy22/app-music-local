import 'package:flutter/material.dart';

/// Chọn thư mục lần đầu — xem [onboarding.md].
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chọn thư mục nhạc')),
      body: Center(
        child: FilledButton(
          onPressed: () {
            // TODO(M0): ViewModel.pickFolder()
          },
          child: const Text('Chọn thư mục'),
        ),
      ),
    );
  }
}

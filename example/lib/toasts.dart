import 'dart:async';
import 'package:flutter/material.dart';
import 'package:contextless_ui/contextless_ui.dart';
import 'demo_item.dart';

// Toasts
List<DialogDemo> get toastDemos => [
      DialogDemo(
        title: 'Simple Message',
        description: 'Basic toast notification',
        icon: Icons.message_outlined,
        color: const Color(0xFF6B7280),
        onTap: () => ContextlessUi.showToast(const Text('Hello World!')),
      ),
      DialogDemo(
        title: 'Success Toast',
        description: 'Success notification toast',
        icon: Icons.check_circle_outline,
        color: const Color(0xFF16A34A),
        onTap: () =>
            ContextlessUi.showToast(const Text('Task completed successfully!')),
      ),
      DialogDemo(
        title: 'Custom Toast',
        description: 'Toast with custom icon',
        icon: Icons.favorite_outline,
        color: const Color(0xFFEC4899),
        onTap: () => ContextlessUi.showToast(
          const Text('Added to favorites'),
          iconLeft: const Icon(Icons.favorite, color: Colors.white, size: 20),
          decoration: const ToastDecoration(
            backgroundColor: Colors.pink,
          ),
        ),
      ),
      DialogDemo(
        title: 'Progress Toast',
        description: 'Toast with progress indicator',
        icon: Icons.download_outlined,
        color: const Color(0xFF3B82F6),
        onTap: () => _showProgressToast(),
      ),
    ];

// Methods
void _showProgressToast() {
  double progress = 0.0;
  const String progressToastId = 'progress-toast';

  void updateProgress() {
    // Update toast with current progress
    ContextlessUi.showToast(
      _ProgressToastContent(
        message: 'Downloading...',
        progress: progress,
      ),
      id: progressToastId,
    );
  }

  updateProgress();

  Timer.periodic(const Duration(milliseconds: 300), (timer) {
    progress += 0.1;
    if (progress >= 1.0) {
      timer.cancel();
      // Close the progress toast
      ContextlessUi.closeToastById(progressToastId);
      // Show completion toast
      ContextlessUi.showToast(
        const Text('Download completed!',
            style: TextStyle(color: Colors.white)),
        iconLeft: const Icon(Icons.check_circle, color: Colors.white),
        decoration: const ToastDecoration(
          backgroundColor: Colors.green,
        ),
      );
    } else {
      updateProgress();
    }
  });
}

// Custom widget for progress toast
class _ProgressToastContent extends StatelessWidget {
  final String message;
  final double progress;

  const _ProgressToastContent({
    required this.message,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    const progressColor = Colors.white;
    const textColor = Colors.white;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            value: progress,
            valueColor: const AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Downloading...',
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: progressColor.withValues(alpha: 0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(progressColor),
                minHeight: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

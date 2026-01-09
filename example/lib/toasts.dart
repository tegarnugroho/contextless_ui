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
    onTap: () => ContextlessToasts.show('Hello World!'),
  ),
  DialogDemo(
    title: 'Success Toast',
    description: 'Success notification toast',
    icon: Icons.check_circle_outline,
    color: const Color(0xFF16A34A),
    onTap: () => ContextlessToasts.show('Task completed successfully!'),
  ),
  DialogDemo(
    title: 'Custom Toast',
    description: 'Toast with custom icon',
    icon: Icons.favorite_outline,
    color: const Color(0xFFEC4899),
    onTap: () => ContextlessToasts.show(
      'Added to favorites',
      iconLeft: const Icon(Icons.favorite, color: Colors.white, size: 20),
      backgroundColor: Colors.pink,
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
  ToastHandle? currentHandle;

  void updateProgress() {
    // Replace previous toast if present
    currentHandle?.close();

    // Show a new progress toast
    currentHandle = ContextlessToasts.progress(
      'Downloading...',
      progress: progress,
      id: 'download-${DateTime.now().millisecondsSinceEpoch}', // unique id
    );
  }

  updateProgress();

  Timer.periodic(const Duration(milliseconds: 300), (timer) {
    progress += 0.1;
    if (progress >= 1.0) {
      timer.cancel();
      currentHandle?.close();
      ContextlessToasts.show(
        'Download completed!',
        backgroundColor: Colors.green,
        iconLeft: const Icon(Icons.check_circle, color: Colors.white),
      );
    } else {
      updateProgress();
    }
  });
}
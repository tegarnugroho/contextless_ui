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
    onTap: () => ContextlessToasts.show(const Text('Hello World!')),
  ),
  DialogDemo(
    title: 'Success Toast',
    description: 'Success notification toast',
    icon: Icons.check_circle_outline,
    color: const Color(0xFF16A34A),
    onTap: () => ContextlessToasts.show(const Text('Task completed successfully!')),
  ),
  DialogDemo(
    title: 'Custom Toast',
    description: 'Toast with custom icon',
    icon: Icons.favorite_outline,
    color: const Color(0xFFEC4899),
    onTap: () => ContextlessToasts.show(
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
  // Show loading toast
  ContextlessToasts.show(
    const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
        SizedBox(width: 12),
        Text('Downloading...'),
      ],
    ),
    id: 'download-toast',
  );

  // Simulate download
  Future.delayed(const Duration(seconds: 2), () {
    ContextlessToasts.closeById('download-toast');
    ContextlessToasts.show(
      const Text('Download completed!'),
      iconLeft: const Icon(Icons.check_circle, color: Colors.white),
      decoration: const ToastDecoration(
        backgroundColor: Colors.green,
      ),
    );
  });
}
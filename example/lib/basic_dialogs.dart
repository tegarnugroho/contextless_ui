import 'package:flutter/material.dart';
import 'package:contextless_ui/contextless_ui.dart';
import 'demo_item.dart';

// Basic Dialogs
List<DialogDemo> get basicDialogs => [
      DialogDemo(
        title: 'Welcome Message',
        description: 'Show a welcome dialog without context',
        icon: Icons.waving_hand,
        color: const Color(0xFF3B82F6),
        onTap: () => _showWelcomeDialog(),
      ),
      DialogDemo(
        title: 'Loading Process',
        description: 'Display loading with auto-close',
        icon: Icons.hourglass_empty,
        color: const Color(0xFFF59E0B),
        onTap: () => _showProcessingDialog(),
      ),
    ];

// Methods
void _showWelcomeDialog() {
  ContextlessUi.dialog.show(const WelcomeDialog(), tag: 'welcome');
}

void _showProcessingDialog() {
  final handle = ContextlessUi.dialog.show(
    const ProcessingDialog(),
    tag: 'processing',
    barrierDismissible: false,
  );

  // Auto-close after 3 seconds via handle
  Future.delayed(const Duration(seconds: 3), () {
    handle.close();
    _showSuccessMessage('Process completed successfully');
  });
}

void _showSuccessMessage(String message) {
  ContextlessSnackbars.show(
    Text(message, style: const TextStyle(color: Colors.white)),
    iconLeft: const Icon(Icons.check_circle),
    decoration: const SnackbarDecoration(
      backgroundColor: Colors.green,
    ),
  );
}

// Welcome Dialog
class WelcomeDialog extends StatelessWidget {
  const WelcomeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.rocket_launch,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to Contextless Dialogs',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'This dialog was created without requiring any BuildContext. Perfect for service layers and background processes.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => ContextlessUi.dialog.closeAll('understood'),
                child: const Text('Got it'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Processing Dialog
class ProcessingDialog extends StatelessWidget {
  const ProcessingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Processing your request',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait a moment...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

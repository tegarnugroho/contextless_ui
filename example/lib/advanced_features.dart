import 'dart:async';
import 'package:flutter/material.dart';
import 'package:contextless_ui/contextless_ui.dart';
import 'demo_item.dart';

// Advanced Features
List<DialogDemo> get advancedFeatures => [
  DialogDemo(
    title: 'Multiple Dialogs',
    description: 'Manage several dialogs with tags',
    icon: Icons.layers_outlined,
    color: const Color(0xFF0891B2),
    onTap: () => _showMultipleDialogs(),
  ),
  DialogDemo(
    title: 'Custom Animations',
    description: 'Showcase different transitions',
    icon: Icons.animation,
    color: const Color(0xFF4F46E5),
    onTap: () => _showCustomTransitions(),
  ),
  DialogDemo(
    title: 'Background Service',
    description: 'Dialog from service layer',
    icon: Icons.cloud_outlined,
    color: const Color(0xFF0D9488),
    onTap: () => _simulateServiceCall(),
  ),
  DialogDemo(
    title: 'Mixed UI Components',
    description: 'Show multiple UI types together',
    icon: Icons.dashboard_outlined,
    color: const Color(0xFF7C3AED),
    onTap: () => _showMixedComponents(),
  ),
];

// Methods
void _showMultipleDialogs() {
  for (int i = 1; i <= 3; i++) {
    ContextlessUi.dialog.show(
      TaskDialog(
        taskNumber: i,
        onClose: () => ContextlessUi.dialog.closeByTag('task-$i'),
      ),
      tag: 'task-$i',
      id: 'multi-$i',
    );
  }
}

void _showCustomTransitions() {
  final transitions = [
    ('Slide from Bottom', DialogTransitions.slideFromBottom),
    ('Slide from Top', DialogTransitions.slideFromTop),
    ('Scale Animation', DialogTransitions.scale),
    ('Fade Animation', DialogTransitions.fade),
    ('Fade + Scale', DialogTransitions.fadeWithScale),
  ];

  for (int i = 0; i < transitions.length; i++) {
    final (name, transition) = transitions[i];
    Timer(Duration(milliseconds: i * 400), () {
      ContextlessUi.dialog.show(
        TransitionDemo(name: name),
        tag: 'transitions',
        transitionsBuilder: transition,
      );
    });
  }
}

void _simulateServiceCall() {
  _showSuccessMessage('Starting background service...');
  Timer(const Duration(seconds: 1), () {
    BackgroundService.processData();
  });
}

void _showMixedComponents() {
  ContextlessToasts.show(
    'Starting multi-component demo...',
    backgroundColor: Colors.blue,
    iconLeft: const Icon(Icons.info, color: Colors.white),
  );

  Timer(const Duration(milliseconds: 500), () {
    ContextlessSnackbars.show(
      const Text('Please wait while we prepare your content', style: TextStyle(color: Colors.white)),
      iconLeft: const Icon(Icons.warning),
      decoration: const SnackbarDecoration(
        backgroundColor: Colors.orange,
      ),
    );
  });

  Timer(const Duration(seconds: 2), () async {
    final completer = Completer<bool?>();
    BottomSheetHandle? handle;

    handle = ContextlessBottomSheets.show(
      Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ready!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text(
                'Your content is ready. Would you like to view it now?'),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      completer.complete(false);
                      handle?.close();
                    },
                    child: const Text('Later'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      completer.complete(true);
                      handle?.close();
                    },
                    child: const Text('View'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );

    final result = await completer.future;

    if (result == true) {
      ContextlessUi.dialog.show(
        const WelcomeDialog(),
        tag: 'mixed-demo',
      );
    }
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

// Task Dialog for multiple dialogs demo
class TaskDialog extends StatelessWidget {
  final int taskNumber;
  final VoidCallback onClose;

  const TaskDialog(
      {super.key, required this.taskNumber, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                '$taskNumber',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Task #$taskNumber',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'This is an example of managing multiple dialogs with different tags.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onClose,
              child: const Text('Close This Task'),
            ),
          ],
        ),
      ),
    );
  }
}

// Transition Demo Dialog
class TransitionDemo extends StatelessWidget {
  final String name;

  const TransitionDemo({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.animation,
                size: 48, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'This dialog uses the $name transition.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => ContextlessUi.dialog.closeByTag('transitions'),
              child: const Text('Close All Transitions'),
            ),
          ],
        ),
      ),
    );
  }
}

// Background Service
class BackgroundService {
  static void processData() {
    Timer(const Duration(seconds: 2), () {
      ContextlessUi.dialog
          .show(const ServiceNotificationDialog(), tag: 'service');
    });
  }
}

// Service Notification Dialog
class ServiceNotificationDialog extends StatelessWidget {
  const ServiceNotificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child:
                  const Icon(Icons.cloud_done, size: 48, color: Colors.green),
            ),
            const SizedBox(height: 24),
            Text(
              'Service Completed',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Background service completed successfully! This dialog was shown from a service layer without any BuildContext.',
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
                onPressed: () => ContextlessUi.dialog.closeByTag('service'),
                child: const Text('Awesome!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Welcome Dialog (needed for mixed components)
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
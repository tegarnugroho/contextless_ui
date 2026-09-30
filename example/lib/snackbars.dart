import 'dart:async';
import 'package:flutter/material.dart';
import 'package:contextless_ui/contextless_ui.dart';
import 'demo_item.dart';

// Snackbars
List<DialogDemo> get snackbarDemos => [
      DialogDemo(
        title: 'Success Message',
        description: 'Show success notification',
        icon: Icons.check_circle_outline,
        color: const Color(0xFF16A34A),
        onTap: () => ContextlessUi.showSnackbar(
          const Text('Operation completed successfully!',
              style: TextStyle(color: Colors.white)),
          decoration: const SnackbarDecoration(
            backgroundColor: Color(0xFF16A34A),
          ),
        ),
      ),
      DialogDemo(
        title: 'Error Alert',
        description: 'Display error message',
        icon: Icons.error_outline,
        color: const Color(0xFFDC2626),
        onTap: () => ContextlessUi.showSnackbar(
          const Text('Something went wrong!',
              style: TextStyle(color: Colors.white)),
          decoration: const SnackbarDecoration(
            backgroundColor: Color(0xFFDC2626),
          ),
        ),
      ),
      DialogDemo(
        title: 'Loading Progress',
        description: 'Show loading snackbar',
        icon: Icons.hourglass_empty,
        color: const Color(0xFFF59E0B),
        onTap: () => _showLoadingSnackbar(),
      ),
      DialogDemo(
        title: 'Action Required',
        description: 'Snackbar with user action',
        icon: Icons.touch_app,
        color: const Color(0xFF8B5CF6),
        onTap: () => _showActionSnackbar(),
      ),
    ];

// Methods
void _showLoadingSnackbar() {
  final handle = ContextlessUi.showSnackbar(
    const Text(
      'Processing your request...',
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    iconLeft: const SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(
        strokeWidth: 2.2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    ),
    decoration: const SnackbarDecoration(
      backgroundColor: Color(0xFF1E293B),
    ),
  );

  Timer(const Duration(seconds: 3), () {
    handle.close();
    ContextlessUi.showSnackbar(
      const Text(
        'Processing completed!',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      iconLeft: const Icon(Icons.check_circle, color: Colors.white),
      decoration: const SnackbarDecoration(
        backgroundColor: Color(0xFF16A34A),
      ),
    );
  });
}

void _showActionSnackbar() async {
  final result = await ContextlessUi.showSnackbarWithAction<bool>(
    const Text('Delete this item?',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
    action: (onPressed) => SnackBarAction(
      label: 'DELETE',
      textColor: const Color(0xFFFDE047),
      onPressed: onPressed,
    ),
    actionValue: true,
    id: 'delete-snackbar',
    decoration: const SnackbarDecoration(
      backgroundColor: Color(0xFFDC2626),
    ),
    duration: const Duration(seconds: 6),
  );

  if (result == true) {
    ContextlessUi.showSnackbar(
      const Text(
        'Item deleted successfully!',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      iconLeft: const Icon(Icons.check_circle, color: Colors.white),
      decoration: const SnackbarDecoration(
        backgroundColor: Color(0xFF16A34A),
      ),
    );
  }
}

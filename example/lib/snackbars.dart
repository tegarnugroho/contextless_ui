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
        onTap: () => ContextlessSnackbars.show(
          'Operation completed successfully!',
          textColor: Colors.white,
          backgroundColor: const Color(0xFF16A34A),
        ),
      ),
      DialogDemo(
        title: 'Error Alert',
        description: 'Display error message',
        icon: Icons.error_outline,
        color: const Color(0xFFDC2626),
        onTap: () => ContextlessSnackbars.show(
          'Something went wrong!',
          textColor: Colors.white,
          backgroundColor: const Color(0xFFDC2626),
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
  final handle = ContextlessSnackbars.show(
    'Processing your request...',
    textColor: Colors.black,
  );
  Timer(const Duration(seconds: 3), () {
    handle.close();
    ContextlessSnackbars.show(
      'Processing completed!',
      textColor: Colors.white,
      backgroundColor: Colors.green,
      iconLeft: const Icon(Icons.check_circle, color: Colors.white),
    );
  });
}

void _showActionSnackbar() async {
  final result = await ContextlessSnackbars.actionAsync<bool>(
    'Delete this item?',
    actionLabel: 'DELETE',
    actionValue: true,
    id: 'delete-snackbar',
    backgroundColor: Colors.red,
    actionTextColor: Colors.white,
    textColor: Colors.white,
    duration: const Duration(seconds: 6),
  );

  if (result == true) {
    ContextlessSnackbars.show(
      'Item deleted successfully!',
      backgroundColor: Colors.green,
      iconLeft: const Icon(Icons.check_circle, color: Colors.white),
    );
  }
}

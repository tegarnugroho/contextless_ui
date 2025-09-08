import 'package:flutter/material.dart';
import 'contextless_ui_core.dart';
import 'ui_handle.dart';

/// Builder class for creating common snackbar types easily
class SnackbarBuilder {
  SnackbarBuilder._();

  /// Creates a simple text snackbar
  ///
  /// Example:
  /// ```dart
  /// SnackbarBuilder.text('Hello World!');
  /// ```
  static UiHandle text(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    Color? textColor,
    SnackBarAction? action,
    bool showCloseIcon = false,
  }) {
    return ContextlessUi.showSnackbar(
      Text(
        message,
        style: TextStyle(color: textColor),
      ),
      id: id,
      tag: tag,
      duration: duration,
      backgroundColor: backgroundColor,
      action: action,
      showCloseIcon: showCloseIcon,
    );
  }

  /// Creates a success snackbar with green styling
  ///
  /// Example:
  /// ```dart
  /// SnackbarBuilder.success('Operation completed successfully!');
  /// ```
  static UiHandle success(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 4),
    bool showCloseIcon = false,
  }) {
    return ContextlessUi.showSnackbar(
      Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      id: id,
      tag: tag,
      duration: duration,
      backgroundColor: Colors.green,
      showCloseIcon: showCloseIcon,
    );
  }

  /// Creates an error snackbar with red styling
  ///
  /// Example:
  /// ```dart
  /// SnackbarBuilder.error('Something went wrong!');
  /// ```
  static UiHandle error(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 6),
    bool showCloseIcon = true,
    SnackBarAction? action,
  }) {
    return ContextlessUi.showSnackbar(
      Row(
        children: [
          const Icon(
            Icons.error,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      id: id,
      tag: tag,
      duration: duration,
      backgroundColor: Colors.red,
      showCloseIcon: showCloseIcon,
      action: action,
    );
  }

  /// Creates a warning snackbar with orange styling
  ///
  /// Example:
  /// ```dart
  /// SnackbarBuilder.warning('Please check your input!');
  /// ```
  static UiHandle warning(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 5),
    bool showCloseIcon = false,
    SnackBarAction? action,
  }) {
    return ContextlessUi.showSnackbar(
      Row(
        children: [
          const Icon(
            Icons.warning,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      id: id,
      tag: tag,
      duration: duration,
      backgroundColor: Colors.orange,
      showCloseIcon: showCloseIcon,
      action: action,
    );
  }

  /// Creates an info snackbar with blue styling
  ///
  /// Example:
  /// ```dart
  /// SnackbarBuilder.info('New feature available!');
  /// ```
  static UiHandle info(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 4),
    bool showCloseIcon = false,
    SnackBarAction? action,
  }) {
    return ContextlessUi.showSnackbar(
      Row(
        children: [
          const Icon(
            Icons.info,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      id: id,
      tag: tag,
      duration: duration,
      backgroundColor: Colors.blue,
      showCloseIcon: showCloseIcon,
      action: action,
    );
  }

  /// Creates a loading snackbar with progress indicator
  ///
  /// Example:
  /// ```dart
  /// final handle = SnackbarBuilder.loading('Processing...');
  /// // Later close it when done:
  /// ContextlessUi.close(handle);
  /// ```
  static UiHandle loading(
    String message, {
    String? id,
    String? tag,
    Duration? duration, // No auto-dismiss by default
    Color? backgroundColor,
  }) {
    return ContextlessUi.showSnackbar(
      Row(
        children: [
          const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      id: id,
      tag: tag,
      duration: duration ?? const Duration(days: 1), // Very long duration
      backgroundColor: backgroundColor ?? Colors.grey[700],
    );
  }

  /// Creates an action snackbar that awaits user response
  ///
  /// Returns a Future that completes with the action result.
  ///
  /// Example:
  /// ```dart
  /// final result = await SnackbarBuilder.actionAsync(
  ///   'Delete this item?',
  ///   actionLabel: 'DELETE',
  ///   actionResult: true,
  /// );
  /// if (result == true) {
  ///   // User confirmed deletion
  /// }
  /// ```
  static Future<T?> actionAsync<T>(
    String message, {
    required String actionLabel,
    required T actionResult,
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 8),
    Color? backgroundColor,
    Color? actionColor,
  }) {
    return ContextlessUi.showSnackbarAsync<T>(
      Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      id: id,
      tag: tag,
      duration: duration,
      backgroundColor: backgroundColor,
      action: SnackBarAction(
        label: actionLabel,
        textColor: actionColor,
        onPressed: () {
          if (id != null) {
            ContextlessUi.closeById(id, actionResult);
          } else if (tag != null) {
            ContextlessUi.closeByTag(tag, actionResult);
          }
        },
      ),
    );
  }
}

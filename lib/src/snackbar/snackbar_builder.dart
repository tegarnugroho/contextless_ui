import 'package:flutter/material.dart';
import 'contextless_snackbar_core.dart';
import 'snackbar_handle.dart';

/// Builder class for creating common snackbar types easily
class SnackbarBuilder {
  SnackbarBuilder._();

  /// Creates a simple text snackbar
  ///
  /// Example:
  /// ```dart
  /// SnackbarBuilder.text('Hello World!');
  /// ```
  static SnackbarHandle text(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    Color? textColor,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    SnackBarAction? action,
  }) {
    return ContextlessSnackbars.show(
      Text(
        message,
        style: TextStyle(color: textColor ?? Colors.white),
      ),
      id: id,
      tag: tag,
      duration: duration,
      backgroundColor: backgroundColor ?? Colors.black87,
      margin: margin,
      padding: padding,
      action: action,
    );
  }

  /// Creates a success snackbar with green styling
  ///
  /// Example:
  /// ```dart
  /// SnackbarBuilder.success('Operation completed successfully!');
  /// ```
  static SnackbarHandle success(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    Color? textColor,
    Widget? icon,
    SnackBarAction? action,
  }) {
    return ContextlessSnackbars.show(
      Row(
        children: [
          icon ?? const Icon(Icons.check_circle, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor ?? Colors.white),
            ),
          ),
        ],
      ),
      id: id,
      tag: tag,
      duration: duration,
      backgroundColor: backgroundColor ?? Colors.green,
      action: action,
    );
  }

  /// Creates an error snackbar with red styling
  ///
  /// Example:
  /// ```dart
  /// SnackbarBuilder.error('Something went wrong!');
  /// ```
  static SnackbarHandle error(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    Color? textColor,
    Widget? icon,
    SnackBarAction? action,
  }) {
    return ContextlessSnackbars.show(
      Row(
        children: [
          icon ?? const Icon(Icons.error, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor ?? Colors.white),
            ),
          ),
        ],
      ),
      id: id,
      tag: tag,
      duration: duration,
      backgroundColor: backgroundColor ?? Colors.red,
      action: action,
    );
  }

  /// Creates a warning snackbar with orange styling
  ///
  /// Example:
  /// ```dart
  /// SnackbarBuilder.warning('Please check your input!');
  /// ```
  static SnackbarHandle warning(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    Color? textColor,
    Widget? icon,
    SnackBarAction? action,
  }) {
    return ContextlessSnackbars.show(
      Row(
        children: [
          icon ?? const Icon(Icons.warning, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor ?? Colors.white),
            ),
          ),
        ],
      ),
      id: id,
      tag: tag,
      duration: duration,
      backgroundColor: backgroundColor ?? Colors.orange,
      action: action,
    );
  }

  /// Creates an info snackbar with blue styling
  ///
  /// Example:
  /// ```dart
  /// SnackbarBuilder.info('Here is some information');
  /// ```
  static SnackbarHandle info(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    Color? textColor,
    Widget? icon,
    SnackBarAction? action,
  }) {
    return ContextlessSnackbars.show(
      Row(
        children: [
          icon ?? const Icon(Icons.info, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor ?? Colors.white),
            ),
          ),
        ],
      ),
      id: id,
      tag: tag,
      duration: duration,
      backgroundColor: backgroundColor ?? Colors.blue,
      action: action,
    );
  }

  /// Creates a loading snackbar with progress indicator
  ///
  /// Example:
  /// ```dart
  /// final handle = SnackbarBuilder.loading('Processing...');
  /// // Later: handle.close();
  /// ```
  static SnackbarHandle loading(
    String message, {
    String? id,
    String? tag,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return ContextlessSnackbars.show(
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
              style: TextStyle(color: textColor ?? Colors.white),
            ),
          ),
        ],
      ),
      id: id,
      tag: tag,
      duration: Duration.zero, // Persistent until manually closed
      backgroundColor: backgroundColor ?? Colors.blueGrey,
    );
  }

  /// Creates a snackbar with an action button that returns a result
  ///
  /// Example:
  /// ```dart
  /// final result = await SnackbarBuilder.actionAsync<bool>(
  ///   'Delete this item?',
  ///   actionLabel: 'DELETE',
  ///   actionValue: true,
  /// );
  /// if (result == true) {
  ///   // User confirmed
  /// }
  /// ```
  static Future<T?> actionAsync<T>(
    String message, {
    required String actionLabel,
    required T actionValue,
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 8),
    Color? backgroundColor,
    Color? textColor,
    Color? actionTextColor,
    Widget? icon,
  }) async {
    late final SnackbarHandle handle;
    
    handle = ContextlessSnackbars.showAsync<T>(
      Row(
        children: [
          if (icon != null) ...[
            icon,
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor ?? Colors.white),
            ),
          ),
        ],
      ),
      id: id,
      tag: tag,
      duration: duration,
      backgroundColor: backgroundColor ?? Colors.black87,
      action: SnackBarAction(
        label: actionLabel,
        textColor: actionTextColor ?? Colors.white,
        onPressed: () {
          handle.complete(actionValue);
        },
      ),
    );
    
    return await handle.result<T>();
  }
}

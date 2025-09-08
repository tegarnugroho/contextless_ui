import 'package:flutter/material.dart';
import 'contextless_ui_core.dart';
import 'ui_handle.dart';

/// Builder class for creating common toast types easily
class ToastBuilder {
  ToastBuilder._();

  /// Creates a simple text toast
  /// 
  /// Example:
  /// ```dart
  /// ToastBuilder.text('Hello World!');
  /// ```
  static UiHandle text(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
    Color? backgroundColor,
    Color? textColor,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) {
    return ContextlessUi.showToast(
      Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.black87,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontSize: 14,
          ),
        ),
      ),
      id: id,
      tag: tag,
      duration: duration,
      alignment: alignment,
    );
  }

  /// Creates a success toast with green styling
  /// 
  /// Example:
  /// ```dart
  /// ToastBuilder.success('Operation completed!');
  /// ```
  static UiHandle success(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
  }) {
    return ContextlessUi.showToast(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      id: id,
      tag: tag,
      duration: duration,
      alignment: alignment,
    );
  }

  /// Creates an error toast with red styling
  /// 
  /// Example:
  /// ```dart
  /// ToastBuilder.error('Something went wrong!');
  /// ```
  static UiHandle error(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 4),
    Alignment alignment = Alignment.bottomCenter,
  }) {
    return ContextlessUi.showToast(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      id: id,
      tag: tag,
      duration: duration,
      alignment: alignment,
    );
  }

  /// Creates a warning toast with orange styling
  /// 
  /// Example:
  /// ```dart
  /// ToastBuilder.warning('Please check your input!');
  /// ```
  static UiHandle warning(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
  }) {
    return ContextlessUi.showToast(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      id: id,
      tag: tag,
      duration: duration,
      alignment: alignment,
    );
  }

  /// Creates an info toast with blue styling
  /// 
  /// Example:
  /// ```dart
  /// ToastBuilder.info('New feature available!');
  /// ```
  static UiHandle info(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
  }) {
    return ContextlessUi.showToast(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.info,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      id: id,
      tag: tag,
      duration: duration,
      alignment: alignment,
    );
  }

  /// Creates a loading toast with progress indicator
  /// 
  /// Example:
  /// ```dart
  /// final handle = ToastBuilder.loading('Processing...');
  /// // Later close it when done:
  /// ContextlessUi.close(handle);
  /// ```
  static UiHandle loading(
    String message, {
    String? id,
    String? tag,
    Duration? duration, // No auto-dismiss by default
    Alignment alignment = Alignment.bottomCenter,
    Color? backgroundColor,
  }) {
    return ContextlessUi.showToast(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
            Flexible(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      id: id,
      tag: tag,
      duration: duration ?? const Duration(days: 1), // Very long duration
      alignment: alignment,
    );
  }

  /// Creates a custom toast with icon
  /// 
  /// Example:
  /// ```dart
  /// ToastBuilder.withIcon(
  ///   Icons.favorite,
  ///   'Added to favorites',
  ///   backgroundColor: Colors.pink,
  /// );
  /// ```
  static UiHandle withIcon(
    IconData icon,
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
    Color? backgroundColor,
    Color? iconColor,
    Color? textColor,
  }) {
    return ContextlessUi.showToast(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.black87,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor ?? Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      id: id,
      tag: tag,
      duration: duration,
      alignment: alignment,
    );
  }

  /// Creates a progress toast that shows a progress bar
  /// 
  /// Example:
  /// ```dart
  /// final handle = ToastBuilder.progress('Downloading...', progress: 0.3);
  /// // Later update progress:
  /// ContextlessUi.close(handle);
  /// ToastBuilder.progress('Downloading...', progress: 0.6, id: 'download');
  /// ```
  static UiHandle progress(
    String message, {
    required double progress,
    String? id,
    String? tag,
    Duration? duration,
    Alignment alignment = Alignment.bottomCenter,
    Color? backgroundColor,
    Color? progressColor,
  }) {
    return ContextlessUi.showToast(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.black87,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progressColor ?? Colors.blue,
                ),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(progress * 100).round()}%',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      id: id,
      tag: tag,
      duration: duration ?? const Duration(days: 1), // Very long duration by default
      alignment: alignment,
    );
  }
}

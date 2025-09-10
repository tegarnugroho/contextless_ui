import 'package:flutter/material.dart';
import '../toast/contextless_toast_core.dart';
import '../toast/toast_handle.dart';

/// Builder class for creating common toast types easily
class ToastBuilder {
  ToastBuilder._();

  /// Creates a simple text toast
  ///
  /// Example:
  /// ```dart
  /// ToastBuilder.text('Hello World!');
  /// ```
  static ToastHandle text(
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
    return ContextlessToasts.show(
      Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
  /// ToastBuilder.success('Operation completed successfully!');
  /// ```
  static ToastHandle success(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
  }) {
    return ContextlessToasts.show(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
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
  static ToastHandle error(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 4),
    Alignment alignment = Alignment.bottomCenter,
  }) {
    return ContextlessToasts.show(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, color: Colors.white, size: 20),
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
  /// ToastBuilder.warning('This action cannot be undone');
  /// ```
  static ToastHandle warning(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
  }) {
    return ContextlessToasts.show(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning, color: Colors.white, size: 20),
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
  /// ToastBuilder.info('New message received');
  /// ```
  static ToastHandle info(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
  }) {
    return ContextlessToasts.show(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info, color: Colors.white, size: 20),
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

  /// Creates a loading toast with circular progress indicator
  ///
  /// Example:
  /// ```dart
  /// final handle = ToastBuilder.loading('Processing...');
  /// // Later when done
  /// handle.close();
  /// ```
  static ToastHandle loading(
    String message, {
    String? id,
    String? tag,
    Alignment alignment = Alignment.bottomCenter,
  }) {
    return ContextlessToasts.show(
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black87,
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
            const SizedBox(width: 8),
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
      duration: Duration.zero, // Don't auto-dismiss loading toasts
      alignment: alignment,
    );
  }

  /// Creates a custom toast with icon
  ///
  /// Example:
  /// ```dart
  /// ToastBuilder.custom(
  ///   message: 'Custom message',
  ///   icon: Icons.star,
  ///   backgroundColor: Colors.purple,
  /// );
  /// ```
  static ToastHandle custom({
    required String message,
    IconData? icon,
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    Color? iconColor,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) {
    return ContextlessToasts.show(
      Container(
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor ?? textColor, size: 20),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                message,
                style: TextStyle(
                  color: textColor,
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

  /// Creates a toast with a custom icon and message
  ///
  /// Example:
  /// ```dart
  /// ToastBuilder.withIcon(Icons.favorite, 'Added to favorites');
  /// ```
  static ToastHandle withIcon(
    IconData icon,
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) {
    return ContextlessToasts.show(
      Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.black87,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor ?? Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              message,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 14,
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

  /// Creates a progress toast with a progress indicator
  ///
  /// Example:
  /// ```dart
  /// ToastBuilder.progress('Downloading...', progress: 0.5);
  /// ```
  static ToastHandle progress(
    String message, {
    double? progress,
    String? id,
    String? tag,
    Alignment alignment = Alignment.bottomCenter,
    Color? backgroundColor,
    Color? textColor,
    Color? progressColor,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
  }) {
    return ContextlessToasts.show(
      Container(
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.black87,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progressColor ?? Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  message,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            if (progress != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progressColor ?? Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      id: id,
      tag: tag,
      duration: Duration.zero, // Persistent until manually closed
      alignment: alignment,
    );
  }
}

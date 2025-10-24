import 'dart:async';
import 'package:flutter/material.dart';

import 'toast_controller.dart';
import 'toast_handle.dart';

/// Main  API for contextless toasts.
class ContextlessToasts {
   ToastController? _controller;

  /// Private constructor to prevent instantiation.
  ContextlessToasts._();

  static final ContextlessToasts instance = ContextlessToasts._();

  /// Initializes the contextless toasts system.
  ///
  /// Either [navigatorKey] or [overlayKey] must be provided.
  /// If [navigatorKey] is provided, the overlay will be obtained from it.
  ///
  /// Example:
  /// ```dart
  /// final navigatorKey = GlobalKey<NavigatorState>();
  /// ContextlessToasts.init(navigatorKey: navigatorKey);
  /// ```
  static void init({
    GlobalKey<NavigatorState>? navigatorKey,
    GlobalKey<OverlayState>? overlayKey,
  }) {
    instance._controller = ToastController();
    instance._controller!.init(
      navigatorKey: navigatorKey,
      overlayKey: overlayKey,
    );
  }

  /// Whether the system has been initialized.
  static bool get isInitialized => instance._controller?.isInitialized ?? false;

  /// Shows a toast without requiring a BuildContext.
  ///
  /// Returns a [ToastHandle] that can be used to close the toast later.
  ///
  /// Parameters:
  /// - [content]: The widget to display as a toast
  /// - [id]: Optional custom ID for the toast (UUID generated if not provided)
  /// - [tag]: Optional tag for grouping toasts
  /// - [duration]: How long the toast should be displayed (set to Duration.zero for persistent)
  /// - [alignment]: Where to position the toast on the screen
  /// - [transitionsBuilder]: Custom transition animation builder
  ///
  /// Example:
  /// ```dart
  /// final handle = ContextlessToasts.show(
  ///   Container(
  ///     padding: EdgeInsets.all(16),
  ///     decoration: BoxDecoration(
  ///       color: Colors.black87,
  ///       borderRadius: BorderRadius.circular(8),
  ///     ),
  ///     child: Text('Hello World!', style: TextStyle(color: Colors.white)),
  ///   ),
  ///   duration: Duration(seconds: 3),
  ///   alignment: Alignment.bottomCenter,
  /// );
  /// ```
  /// Shows a toast with customizable styling.
  ///
  /// Returns a [ToastHandle] that can be used to close the toast later.
  ///
  /// Parameters:
  /// - [message]: The text message to display
  /// - [backgroundColor]: Background color of the toast
  /// - [textColor]: Text color of the message
  /// - [iconLeft]: Optional icon to display on the left side
  /// - [iconRight]: Optional icon to display on the right side
  /// - [duration]: How long the toast should be displayed
  /// - [alignment]: Where to position the toast on the screen
  /// - [padding]: Internal padding of the toast
  /// - [borderRadius]: Border radius for the toast
  /// - [elevation]: Shadow elevation
  /// - [id]: Optional custom ID for the toast
  /// - [tag]: Optional tag for grouping toasts
  ///
  /// Example:
  /// ```dart
  /// final handle = ContextlessToasts.show(
  ///   'Operation completed successfully!',
  ///   backgroundColor: Colors.green,
  ///   iconLeft: Icon(Icons.check_circle, color: Colors.white),
  ///   duration: Duration(seconds: 3),
  ///   alignment: Alignment.bottomCenter,
  /// );
  /// ```
  static ToastHandle show(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
    Color? backgroundColor,
    Color? textColor,
    Widget? iconLeft,
    Widget? iconRight,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    double? elevation,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    instance._ensureInitialized();
    
    // Build content widget with styling and icons
    Widget content = instance._buildToastContent(
      message: message,
      backgroundColor: backgroundColor,
      textColor: textColor,
      iconLeft: iconLeft,
      iconRight: iconRight,
      padding: padding,
      borderRadius: borderRadius,
      elevation: elevation,
    );
    
    return instance._controller!.showToast(
      content,
      id: id,
      tag: tag,
      duration: duration,
      alignment: alignment,
      transitionsBuilder: transitionsBuilder,
    );
  }

  /// Shows a progress toast with a loading indicator and optional progress bar.
  ///
  /// Returns a [ToastHandle] that can be used to close the toast later.
  ///
  /// Parameters:
  /// - [message]: The text message to display
  /// - [progress]: Optional progress value between 0.0 and 1.0 for a progress bar
  /// - [backgroundColor]: Background color of the toast
  /// - [textColor]: Text color of the message
  /// - [progressColor]: Color of the progress bar/indicator
  /// - [duration]: How long the toast should be displayed (typically persistent for progress)
  /// - [alignment]: Where to position the toast on the screen
  /// - [padding]: Internal padding of the toast
  /// - [borderRadius]: Border radius for the toast
  /// - [elevation]: Shadow elevation
  /// - [id]: Optional custom ID for the toast
  /// - [tag]: Optional tag for grouping toasts
  ///
  /// Example:
  /// ```dart
  /// final handle = ContextlessToasts.progress(
  ///   'Downloading...',
  ///   progress: 0.5, // 50% progress
  ///   backgroundColor: Colors.blue,
  ///   duration: Duration.zero, // Persistent until manually closed
  /// );
  /// ```
  static ToastHandle progress(
    String message, {
    String? id,
    String? tag,
    double? progress,
    Duration duration = Duration.zero,
    Alignment alignment = Alignment.bottomCenter,
    Color? backgroundColor,
    Color? textColor,
    Color? progressColor,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    double? elevation,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    instance._ensureInitialized();
    
    // Build content widget with progress indicator
    Widget content = instance._buildProgressToastContent(
      message: message,
      progress: progress,
      backgroundColor: backgroundColor,
      textColor: textColor,
      progressColor: progressColor,
      padding: padding,
      borderRadius: borderRadius,
      elevation: elevation,
    );
    
    return instance._controller!.showToast(
      content,
      id: id,
      tag: tag,
      duration: duration,
      alignment: alignment,
      transitionsBuilder: transitionsBuilder,
    );
  }

  /// Closes a specific toast by its handle.
  ///
  /// Returns true if the toast was found and closed, false otherwise.
  ///
  /// Example:
  /// ```dart
  /// final handle = ContextlessToasts.show(myToast);
  /// // Later...
  /// final closed = await ContextlessToasts.close(handle);
  /// ```
  static Future<bool> close(ToastHandle handle) async {
    if (instance._controller == null) return false;
    return await instance._controller!.close(handle);
  }

  /// Closes a toast by its ID.
  ///
  /// Returns true if a toast with the given ID was found and closed.
  ///
  /// Example:
  /// ```dart
  /// ContextlessToasts.show(myToast, id: 'my-toast');
  /// // Later...
  /// final closed = await ContextlessToasts.closeById('my-toast');
  /// ```
  static Future<bool> closeById(String id) async {
    if (instance._controller == null) return false;
    return await instance._controller!.closeById(id);
  }

  /// Closes all toasts with a specific tag.
  ///
  /// Returns the number of toasts that were closed.
  ///
  /// Example:
  /// ```dart
  /// ContextlessToasts.show(toast1, tag: 'notifications');
  /// ContextlessToasts.show(toast2, tag: 'notifications');
  /// // Later...
  /// final count = await ContextlessToasts.closeByTag('notifications'); // Returns 2
  /// ```
  static Future<int> closeByTag(String tag) async {
    if (instance._controller == null) return 0;
    return await instance._controller!.closeByTag(tag);
  }

  /// Closes all currently active toasts.
  ///
  /// Returns the number of toasts that were closed.
  ///
  /// Example:
  /// ```dart
  /// final count = await ContextlessToasts.closeAll();
  /// print('Closed $count toasts');
  /// ```
  static Future<int> closeAll() async {
    if (instance._controller == null) return 0;
    return await instance._controller!.closeAll();
  }

  /// Gets all currently active toast handles.
  ///
  /// This can be useful for inspecting or managing active toasts.
  ///
  /// Example:
  /// ```dart
  /// final activeToasts = ContextlessToasts.getActiveHandles();
  /// print('Currently showing ${activeToasts.length} toasts');
  /// ```
   List<ToastHandle> getActiveHandles() {
    if (_controller == null) return [];
    return _controller!.activeHandles;
  }

  /// Gets a specific toast handle by its ID.
  ///
  /// Returns null if no toast with the given ID is currently active.
  ///
  /// Example:
  /// ```dart
  /// final handle = ContextlessToasts.getById('my-toast');
  /// if (handle != null) {
  ///   print('Toast is still active');
  /// }
  /// ```
   ToastHandle? getById(String id) {
    if (_controller == null) return null;
    return _controller!.getById(id);
  }

  /// Gets all toast handles with a specific tag.
  ///
  /// Example:
  /// ```dart
  /// final notificationToasts = ContextlessToasts.getByTag('notifications');
  /// print('${notificationToasts.length} notification toasts active');
  /// ```
   List<ToastHandle> getByTag(String tag) {
    if (_controller == null) return [];
    return _controller!.getByTag(tag);
  }

  /// Checks if a toast with the given ID is currently active.
  ///
  /// Example:
  /// ```dart
  /// if (ContextlessToasts.isActive('my-toast')) {
  ///   print('Toast is still showing');
  /// }
  /// ```
   bool isActive(String id) {
    if (_controller == null) return false;
    return _controller!.overlayManager?.isActive(id) ?? false;
  }

  /// Gets the count of currently active toasts.
  ///
  /// Example:
  /// ```dart
  /// final count = ContextlessToasts.getActiveCount();
  /// print('Currently showing $count toasts');
  /// ```
  static int getActiveCount() {
    if (instance._controller == null) return 0;
    return instance._controller!.overlayManager?.activeCount ?? 0;
  }

  /// Disposes the toast system and closes all active toasts.
  ///
  /// This should be called when shutting down the application
  /// or when you no longer need the toast system.
  ///
  /// Example:
  /// ```dart
  /// ContextlessToasts.dispose();
  /// ```
  static void dispose() {
    instance._controller?.dispose();
    instance._controller = null;
  }

  /// Ensures the system is initialized before use.
  void _ensureInitialized() {
    if (!isInitialized) {
      throw StateError(
        'ContextlessToasts not initialized. Call ContextlessToasts.init() first.',
      );
    }
  }

  /// Builds the toast content widget with styling and icons.
  Widget _buildToastContent({
    required String message,
    Color? backgroundColor,
    Color? textColor,
    Widget? iconLeft,
    Widget? iconRight,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    double? elevation,
  }) {
    List<Widget> children = [];
    
    if (iconLeft != null) {
      children.add(iconLeft);
      children.add(const SizedBox(width: 8));
    }
    
    children.add(Expanded(
      child: Text(
        message,
        style: TextStyle(color: textColor ?? Colors.white),
      ),
    ));
    
    if (iconRight != null) {
      children.add(const SizedBox(width: 8));
      children.add(iconRight);
    }
    
    Widget content = Row(children: children);
    
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.black87,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        boxShadow: elevation != null ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: elevation,
            offset: Offset(0, elevation / 2),
          ),
        ] : null,
      ),
      child: content,
    );
  }

  /// Builds the progress toast content widget.
  Widget _buildProgressToastContent({
    required String message,
    double? progress,
    Color? backgroundColor,
    Color? textColor,
    Color? progressColor,
    EdgeInsetsGeometry? padding,
    BorderRadius? borderRadius,
    double? elevation,
  }) {
    List<Widget> children = [];
    
    // Add loading indicator
    children.add(SizedBox(
      width: 16,
      height: 16,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          progressColor ?? Colors.white,
        ),
        value: progress, // null for indeterminate, value for determinate
      ),
    ));
    
    children.add(const SizedBox(width: 12));
    
    // Add message
    children.add(Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(color: textColor ?? Colors.white),
          ),
          if (progress != null) ...[
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: (progressColor ?? Colors.white).withValues(alpha: 0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                progressColor ?? Colors.white,
              ),
            ),
          ],
        ],
      ),
    ));
    
    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
    
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.black87,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        boxShadow: elevation != null ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: elevation,
            offset: Offset(0, elevation / 2),
          ),
        ] : null,
      ),
      child: content,
    );
  }
}

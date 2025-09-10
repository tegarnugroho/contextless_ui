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
   void init({
    GlobalKey<NavigatorState>? navigatorKey,
    GlobalKey<OverlayState>? overlayKey,
  }) {
    _controller = ToastController();
    _controller!.init(
      navigatorKey: navigatorKey,
      overlayKey: overlayKey,
    );
  }

  /// Whether the system has been initialized.
   bool get isInitialized => _controller?.isInitialized ?? false;

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
   ToastHandle show(
    Widget content, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    _ensureInitialized();
    return _controller!.showToast(
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
   Future<bool> close(ToastHandle handle) async {
    if (_controller == null) return false;
    return await _controller!.close(handle);
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
   Future<bool> closeById(String id) async {
    if (_controller == null) return false;
    return await _controller!.closeById(id);
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
   Future<int> closeByTag(String tag) async {
    if (_controller == null) return 0;
    return await _controller!.closeByTag(tag);
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
   Future<int> closeAll() async {
    if (_controller == null) return 0;
    return await _controller!.closeAll();
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
   int getActiveCount() {
    if (_controller == null) return 0;
    return _controller!.overlayManager?.activeCount ?? 0;
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
   void dispose() {
    _controller?.dispose();
    _controller = null;
  }

  /// Ensures the system is initialized before use.
   void _ensureInitialized() {
    if (!isInitialized) {
      throw StateError(
        'ContextlessToasts not initialized. Call ContextlessToasts.init() first.',
      );
    }
  }
}

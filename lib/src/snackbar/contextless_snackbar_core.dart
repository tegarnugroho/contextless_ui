import 'dart:async';
import 'package:flutter/material.dart';

import 'snackbar_controller.dart';
import 'snackbar_handle.dart';

/// Main static API for contextless snackbars.
class ContextlessSnackbars {
  static SnackbarController? _controller;

  /// Private constructor to prevent instantiation.
  ContextlessSnackbars._();

  /// Initializes the contextless snackbars system.
  ///
  /// Either [navigatorKey] or [overlayKey] must be provided.
  /// If [navigatorKey] is provided, the overlay will be obtained from it.
  ///
  /// Example:
  /// ```dart
  /// final navigatorKey = GlobalKey<NavigatorState>();
  /// ContextlessSnackbars.init(navigatorKey: navigatorKey);
  /// ```
  static void init({
    GlobalKey<NavigatorState>? navigatorKey,
    GlobalKey<OverlayState>? overlayKey,
  }) {
    _controller = SnackbarController();
    _controller!.init(
      navigatorKey: navigatorKey,
      overlayKey: overlayKey,
    );
  }

  /// Whether the system has been initialized.
  static bool get isInitialized => _controller?.isInitialized ?? false;

  /// Shows a snackbar without requiring a BuildContext.
  ///
  /// Returns a [SnackbarHandle] that can be used to close the snackbar later.
  ///
  /// Parameters:
  /// - [content]: The widget to display as a snackbar
  /// - [id]: Optional custom ID for the snackbar (UUID generated if not provided)
  /// - [tag]: Optional tag for grouping snackbars
  /// - [duration]: How long the snackbar should be displayed (set to Duration.zero for persistent)
  /// - [backgroundColor]: Background color of the snackbar
  /// - [margin]: Margin around the snackbar
  /// - [padding]: Padding inside the snackbar
  /// - [elevation]: Elevation of the snackbar
  /// - [shape]: Shape border for the snackbar
  /// - [behavior]: Whether the snackbar is floating or fixed
  /// - [action]: Optional action button
  /// - [width]: Width of the snackbar
  /// - [dismissDirection]: Direction for swipe-to-dismiss
  /// - [showCloseIcon]: Whether to show a close icon
  /// - [closeIconColor]: Color of the close icon
  /// - [transitionsBuilder]: Custom transition animation builder
  ///
  /// Example:
  /// ```dart
  /// final handle = ContextlessSnackbars.show(
  ///   Text('Hello World!'),
  ///   duration: Duration(seconds: 4),
  ///   backgroundColor: Colors.green,
  ///   action: SnackBarAction(
  ///     label: 'Undo',
  ///     onPressed: () => print('Undo pressed'),
  ///   ),
  /// );
  /// ```
  static SnackbarHandle show(
    Widget content, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? elevation,
    ShapeBorder? shape,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    SnackBarAction? action,
    double? width,
    DismissDirection dismissDirection = DismissDirection.down,
    bool showCloseIcon = false,
    Color? closeIconColor,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    _ensureInitialized();
    return _controller!.showSnackbar(
      content,
      id: id,
      tag: tag,
      duration: duration,
      backgroundColor: backgroundColor,
      margin: margin,
      padding: padding,
      elevation: elevation,
      shape: shape,
      behavior: behavior,
      action: action,
      width: width,
      dismissDirection: dismissDirection,
      showCloseIcon: showCloseIcon,
      closeIconColor: closeIconColor,
      transitionsBuilder: transitionsBuilder,
    );
  }

  /// Creates an async snackbar that returns a result when closed.
  ///
  /// Similar to [show] but returns a [SnackbarHandle] that can wait for
  /// a result using the [SnackbarHandle.result] method.
  ///
  /// Example:
  /// ```dart
  /// final handle = ContextlessSnackbars.showAsync<String>(
  ///   Row(
  ///     children: [
  ///       Text('Do you want to continue?'),
  ///       TextButton(
  ///         onPressed: () => handle.complete('yes'),
  ///         child: Text('Yes'),
  ///       ),
  ///       TextButton(
  ///         onPressed: () => handle.complete('no'),
  ///         child: Text('No'),
  ///       ),
  ///     ],
  ///   ),
  ///   duration: Duration.zero, // Persistent until user responds
  /// );
  /// 
  /// final result = await handle.result<String>();
  /// print('User selected: $result');
  /// ```
  static SnackbarHandle showAsync<T>(
    Widget content, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? elevation,
    ShapeBorder? shape,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    SnackBarAction? action,
    double? width,
    DismissDirection dismissDirection = DismissDirection.down,
    bool showCloseIcon = false,
    Color? closeIconColor,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    _ensureInitialized();
    
    final handle = SnackbarHandle.async(id: id, tag: tag);
    
    _controller!.show(
      content,
      id: handle.id,
      tag: tag,
      options: {
        'duration': duration,
        'backgroundColor': backgroundColor,
        'margin': margin,
        'padding': padding,
        'elevation': elevation,
        'shape': shape,
        'behavior': behavior,
        'action': action,
        'width': width,
        'dismissDirection': dismissDirection,
        'showCloseIcon': showCloseIcon,
        'closeIconColor': closeIconColor,
        'transitionsBuilder': transitionsBuilder,
      },
    );
    
    return handle;
  }

  /// Closes a specific snackbar by its handle.
  ///
  /// Returns true if the snackbar was found and closed, false otherwise.
  ///
  /// Example:
  /// ```dart
  /// final handle = ContextlessSnackbars.show(mySnackbar);
  /// // Later...
  /// final closed = await ContextlessSnackbars.close(handle);
  /// ```
  static Future<bool> close(SnackbarHandle handle) async {
    if (_controller == null) return false;
    return await _controller!.close(handle);
  }

  /// Closes a snackbar by its ID.
  ///
  /// Returns true if a snackbar with the given ID was found and closed.
  ///
  /// Example:
  /// ```dart
  /// ContextlessSnackbars.show(mySnackbar, id: 'my-snackbar');
  /// // Later...
  /// final closed = await ContextlessSnackbars.closeById('my-snackbar');
  /// ```
  static Future<bool> closeById(String id) async {
    if (_controller == null) return false;
    return await _controller!.closeById(id);
  }

  /// Closes all snackbars with a specific tag.
  ///
  /// Returns the number of snackbars that were closed.
  ///
  /// Example:
  /// ```dart
  /// ContextlessSnackbars.show(snackbar1, tag: 'notifications');
  /// ContextlessSnackbars.show(snackbar2, tag: 'notifications');
  /// // Later...
  /// final count = await ContextlessSnackbars.closeByTag('notifications'); // Returns 2
  /// ```
  static Future<int> closeByTag(String tag) async {
    if (_controller == null) return 0;
    return await _controller!.closeByTag(tag);
  }

  /// Closes all currently active snackbars.
  ///
  /// Returns the number of snackbars that were closed.
  ///
  /// Example:
  /// ```dart
  /// final count = await ContextlessSnackbars.closeAll();
  /// print('Closed $count snackbars');
  /// ```
  static Future<int> closeAll() async {
    if (_controller == null) return 0;
    return await _controller!.closeAll();
  }

  /// Gets all currently active snackbar handles.
  ///
  /// This can be useful for inspecting or managing active snackbars.
  ///
  /// Example:
  /// ```dart
  /// final activeSnackbars = ContextlessSnackbars.getActiveHandles();
  /// print('Currently showing ${activeSnackbars.length} snackbars');
  /// ```
  static List<SnackbarHandle> getActiveHandles() {
    if (_controller == null) return [];
    return _controller!.activeHandles;
  }

  /// Gets a specific snackbar handle by its ID.
  ///
  /// Returns null if no snackbar with the given ID is currently active.
  ///
  /// Example:
  /// ```dart
  /// final handle = ContextlessSnackbars.getById('my-snackbar');
  /// if (handle != null) {
  ///   print('Snackbar is still active');
  /// }
  /// ```
  static SnackbarHandle? getById(String id) {
    if (_controller == null) return null;
    return _controller!.getById(id);
  }

  /// Gets all snackbar handles with a specific tag.
  ///
  /// Example:
  /// ```dart
  /// final notificationSnackbars = ContextlessSnackbars.getByTag('notifications');
  /// print('${notificationSnackbars.length} notification snackbars active');
  /// ```
  static List<SnackbarHandle> getByTag(String tag) {
    if (_controller == null) return [];
    return _controller!.getByTag(tag);
  }

  /// Checks if a snackbar with the given ID is currently active.
  ///
  /// Example:
  /// ```dart
  /// if (ContextlessSnackbars.isActive('my-snackbar')) {
  ///   print('Snackbar is still showing');
  /// }
  /// ```
  static bool isActive(String id) {
    if (_controller == null) return false;
    return _controller!.overlayManager?.isActive(id) ?? false;
  }

  /// Gets the count of currently active snackbars.
  ///
  /// Example:
  /// ```dart
  /// final count = ContextlessSnackbars.getActiveCount();
  /// print('Currently showing $count snackbars');
  /// ```
  static int getActiveCount() {
    if (_controller == null) return 0;
    return _controller!.overlayManager?.activeCount ?? 0;
  }

  /// Disposes the snackbar system and closes all active snackbars.
  ///
  /// This should be called when shutting down the application
  /// or when you no longer need the snackbar system.
  ///
  /// Example:
  /// ```dart
  /// ContextlessSnackbars.dispose();
  /// ```
  static void dispose() {
    _controller?.dispose();
    _controller = null;
  }

  /// Ensures the system is initialized before use.
  static void _ensureInitialized() {
    if (!isInitialized) {
      throw StateError(
        'ContextlessSnackbars not initialized. Call ContextlessSnackbars.init() first.',
      );
    }
  }
}

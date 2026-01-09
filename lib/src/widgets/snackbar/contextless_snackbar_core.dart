import 'dart:async';
import 'package:flutter/material.dart';

import 'snackbar_controller.dart';
import 'snackbar_handle.dart';

/// Model for snackbar visual decoration properties.
class SnackbarDecoration {
  /// Background color of the snackbar
  final Color? backgroundColor;

  /// Margin around the snackbar
  final EdgeInsetsGeometry? margin;

  /// Padding inside the snackbar
  final EdgeInsetsGeometry? padding;

  /// Elevation of the snackbar
  final double? elevation;

  /// Shape border for the snackbar
  final ShapeBorder? shape;

  /// Width of the snackbar
  final double? width;

  /// Whether the snackbar is floating or fixed
  final SnackBarBehavior behavior;

  /// Direction for swipe-to-dismiss
  final DismissDirection dismissDirection;

  /// Whether to show a close icon
  final bool showCloseIcon;

  /// Color of the close icon
  final Color? closeIconColor;

  /// Custom transition animation builder
  final RouteTransitionsBuilder? transitionsBuilder;

  const SnackbarDecoration({
    this.backgroundColor,
    this.margin,
    this.padding,
    this.elevation,
    this.shape,
    this.width,
    this.behavior = SnackBarBehavior.floating,
    this.dismissDirection = DismissDirection.down,
    this.showCloseIcon = false,
    this.closeIconColor,
    this.transitionsBuilder,
  });
}

/// Main  API for contextless snackbars.
class ContextlessSnackbars {
  SnackbarController? _controller;

  /// Private constructor to prevent instantiation.
  ContextlessSnackbars._();

  static final ContextlessSnackbars instance = ContextlessSnackbars._();

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
    instance._controller = SnackbarController();
    instance._controller!.init(
      navigatorKey: navigatorKey,
      overlayKey: overlayKey,
    );

    // Set the close callback for handles
    SnackbarHandle.setCloseCallback((handle) => instance.close(handle));
  }

  /// Whether the system has been initialized.
  static bool get isInitialized => instance._controller?.isInitialized ?? false;

  /// Shows a snackbar without requiring a BuildContext.
  ///
  /// Returns a [SnackbarHandle] that can be used to close the snackbar later.
  ///
  /// Parameters:
  /// - [content]: The widget to display as a snackbar content
  /// - [id]: Optional custom ID for the snackbar (UUID generated if not provided)
  /// - [tag]: Optional tag for grouping snackbars
  /// - [duration]: How long the snackbar should be displayed (set to Duration.zero for persistent)
  /// - [action]: Optional action widget (can be any widget, not limited to SnackBarAction)
  /// - [decoration]: Visual decoration properties for the snackbar
  /// - [iconLeft]: Optional icon to display on the left side (shortcut for simple use cases)
  /// - [iconRight]: Optional icon to display on the right side (shortcut for simple use cases)
  ///
  /// Example:
  /// ```dart
  /// final handle = ContextlessSnackbars.show(
  ///   content: Text('Hello World!'),
  ///   duration: Duration(seconds: 4),
  ///   decoration: SnackbarDecoration(
  ///     backgroundColor: Colors.green,
  ///   ),
  ///   action: SnackBarAction(
  ///     label: 'Undo',
  ///     onPressed: () => print('Undo pressed'),
  ///   ),
  /// );
  /// ```
  ///
  /// For simple text messages with icons:
  /// ```dart
  /// final handle = ContextlessSnackbars.show(
  ///   content: Text('Operation completed successfully!'),
  ///   iconLeft: Icon(Icons.check_circle),
  ///   decoration: SnackbarDecoration(
  ///     backgroundColor: Colors.green,
  ///   ),
  /// );
  /// ```
  static SnackbarHandle show(
    Widget content, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 4),
    Widget? action,
    SnackbarDecoration? decoration,
    Widget? iconLeft,
    Widget? iconRight,
  }) {
    instance._ensureInitialized();

    // Apply icon shortcuts if provided
    Widget finalContent = content;
    if (iconLeft != null || iconRight != null) {
      finalContent = instance._buildSnackbarContentWithIcons(
        content: content,
        iconLeft: iconLeft,
        iconRight: iconRight,
      );
    }

    return instance._controller!.showSnackbar(
      finalContent,
      id: id,
      tag: tag,
      duration: duration,
      backgroundColor: decoration?.backgroundColor,
      margin: decoration?.margin,
      padding: decoration?.padding,
      elevation: decoration?.elevation,
      shape: decoration?.shape,
      behavior: decoration?.behavior ?? SnackBarBehavior.floating,
      action: action,
      width: decoration?.width,
      dismissDirection: decoration?.dismissDirection ?? DismissDirection.down,
      showCloseIcon: decoration?.showCloseIcon ?? false,
      closeIconColor: decoration?.closeIconColor,
      transitionsBuilder: decoration?.transitionsBuilder,
    );
  }

  /// Creates an async snackbar that returns a result when closed.
  ///
  /// Similar to [show] but returns a [SnackbarHandle] that can wait for
  /// a result using the [SnackbarHandle.result] method.
  ///
  /// Example:
  /// ```dart
  /// final result = await ContextlessSnackbars.showAsync<String>(
  ///   content: Text('Do you want to continue?'),
  ///   iconLeft: Icon(Icons.question_mark),
  ///   action: SnackBarAction(
  ///     label: 'Yes',
  ///     onPressed: () => handle.complete('yes'),
  ///   ),
  ///   duration: Duration.zero, // Persistent until user responds
  /// );
  /// ```
  static SnackbarHandle showAsync<T>(
    Widget content, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 4),
    Widget? action,
    SnackbarDecoration? decoration,
    Widget? iconLeft,
    Widget? iconRight,
  }) {
    instance._ensureInitialized();

    final handle = SnackbarHandle.async(id: id, tag: tag);

    // Apply icon shortcuts if provided
    Widget finalContent = content;
    if (iconLeft != null || iconRight != null) {
      finalContent = instance._buildSnackbarContentWithIcons(
        content: content,
        iconLeft: iconLeft,
        iconRight: iconRight,
      );
    }

    instance._controller!.show(
      finalContent,
      id: handle.id,
      tag: tag,
      options: {
        'duration': duration,
        'backgroundColor': decoration?.backgroundColor,
        'margin': decoration?.margin,
        'padding': decoration?.padding,
        'elevation': decoration?.elevation,
        'shape': decoration?.shape,
        'behavior': decoration?.behavior ?? SnackBarBehavior.floating,
        'action': action,
        'width': decoration?.width,
        'dismissDirection': decoration?.dismissDirection ?? DismissDirection.down,
        'showCloseIcon': decoration?.showCloseIcon ?? false,
        'closeIconColor': decoration?.closeIconColor,
        'transitionsBuilder': decoration?.transitionsBuilder,
      },
    );

    return handle;
  }

  ///
  /// final result = await handle.result<String>();
  /// print('User selected: $result');
  /// ```
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
  Future<bool> close(SnackbarHandle handle) async {
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
    if (instance._controller == null) return false;
    return await instance._controller!.closeById(id);
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
    if (instance._controller == null) return 0;
    return await instance._controller!.closeByTag(tag);
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
    if (instance._controller == null) return 0;
    return await instance._controller!.closeAll();
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
  List<SnackbarHandle> getActiveHandles() {
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
  SnackbarHandle? getById(String id) {
    if (_controller == null) return null;
    return _controller!.getById(id);
  }

  /// Gets all snackbar handles with a specific tag.
  /// Gets all snackbar handles with a specific tag.
  ///
  /// Example:
  /// ```dart
  /// final notificationSnackbars = ContextlessSnackbars.getByTag('notifications');
  /// print('${notificationSnackbars.length} notification snackbars active');
  /// ```
  List<SnackbarHandle> getByTag(String tag) {
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
  bool isActive(String id) {
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
    if (instance._controller == null) return 0;
    return instance._controller!.overlayManager?.activeCount ?? 0;
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
    instance._controller?.dispose();
    instance._controller = null;
  }

  /// Shows an async snackbar with an action button that returns a value when pressed.
  ///
  /// This is a convenience method for creating action-based snackbars that
  /// return a specific value when the action is pressed.
  ///
  /// Parameters:
  /// - [content]: The widget to display as snackbar content
  /// - [actionLabel]: The text for the action button
  /// - [actionValue]: The value to return when the action is pressed
  /// - [actionTextColor]: Color of the action button text
  /// - Other parameters same as [show] method
  ///
  /// Returns a Future that completes with the [actionValue] when the action
  /// is pressed, or null if the snackbar is dismissed without action.
  ///
  /// Example:
  /// ```dart
  /// final result = await ContextlessSnackbars.actionAsync<bool>(
  ///   content: Text('Delete this item?'),
  ///   actionLabel: 'DELETE',
  ///   actionValue: true,
  ///   decoration: SnackbarDecoration(
  ///     backgroundColor: Colors.red,
  ///   ),
  /// );
  ///
  /// if (result == true) {
  ///   print('User confirmed deletion');
  /// }
  /// ```
  static Future<T?> actionAsync<T>(
    Widget content, {
    required String actionLabel,
    required T actionValue,
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 6),
    Color? actionTextColor,
    SnackbarDecoration? decoration,
    Widget? iconLeft,
    Widget? iconRight,
  }) async {
    instance._ensureInitialized();

    final completer = Completer<T?>();
    final snackbarId = id ?? 'action-${DateTime.now().millisecondsSinceEpoch}';

    final action = SnackBarAction(
      label: actionLabel,
      textColor: actionTextColor,
      onPressed: () {
        if (!completer.isCompleted) {
          completer.complete(actionValue);
        }
        closeById(snackbarId);
      },
    );

    final handle = show(
      content,
      id: snackbarId,
      tag: tag,
      duration: duration,
      action: action,
      decoration: decoration,
      iconLeft: iconLeft,
      iconRight: iconRight,
    );

    // Complete with null if snackbar is closed without action
    handle.result().then((_) {
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    });

    return completer.future;
  }

  /// Ensures the system is initialized before use.
  void _ensureInitialized() {
    if (!isInitialized) {
      throw StateError(
        'ContextlessSnackbars not initialized. Call ContextlessSnackbars.init() first.',
      );
    }
  }

  /// Builds the snackbar content widget with optional icons.
  Widget _buildSnackbarContentWithIcons({
    required Widget content,
    Widget? iconLeft,
    Widget? iconRight,
  }) {
    List<Widget> children = [];

    if (iconLeft != null) {
      children.add(iconLeft);
      children.add(const SizedBox(width: 8));
    }

    children.add(Expanded(child: content));

    if (iconRight != null) {
      children.add(const SizedBox(width: 8));
      children.add(iconRight);
    }

    return Row(children: children);
  }
}

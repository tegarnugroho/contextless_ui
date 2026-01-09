import 'dart:async';
import 'package:flutter/material.dart';

import 'snackbar_controller.dart';
import 'snackbar_handle.dart';

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
  /// Shows a snackbar with customizable styling.
  ///
  /// Returns a [SnackbarHandle] that can be used to close the snackbar later.
  ///
  /// Parameters:
  /// - [message]: The text message to display
  /// - [backgroundColor]: Background color of the snackbar
  /// - [textColor]: Text color of the message
  /// - [iconLeft]: Optional icon to display on the left side
  /// - [iconRight]: Optional icon to display on the right side
  /// - [action]: Optional action widget (usually a SnackBarAction)
  /// - [duration]: How long the snackbar should be displayed
  /// - [margin]: Margin around the snackbar
  /// - [padding]: Internal padding of the snackbar
  /// - [elevation]: Shadow elevation
  /// - [behavior]: Whether snackbar floats or is fixed
  /// - [shape]: Custom shape for the snackbar
  /// - [id]: Optional custom ID for the snackbar
  /// - [tag]: Optional tag for grouping snackbars
  ///
  /// Example:
  /// ```dart
  /// final handle = ContextlessSnackbars.show(
  ///   'Operation completed successfully!',
  ///   backgroundColor: Colors.green,
  ///   iconLeft: Icon(Icons.check_circle, color: Colors.white),
  ///   action: SnackBarAction(
  ///     label: 'Undo',
  ///     onPressed: () => print('Undo pressed'),
  ///   ),
  /// );
  /// ```
  static SnackbarHandle show(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    Color? textColor,
    Widget? iconLeft,
    Widget? iconRight,
    SnackBarAction? action,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? elevation,
    ShapeBorder? shape,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    double? width,
    DismissDirection dismissDirection = DismissDirection.down,
    bool showCloseIcon = false,
    Color? closeIconColor,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    instance._ensureInitialized();

    // Build content widget with icons
    Widget content = instance._buildSnackbarContent(
      message: message,
      textColor: textColor ?? Colors.white,
      iconLeft: iconLeft,
      iconRight: iconRight,
    );

    return instance._controller!.showSnackbar(
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
  /// final result = await ContextlessSnackbars.showAsync<String>(
  ///   'Do you want to continue?',
  ///   iconLeft: Icon(Icons.question_mark),
  ///   action: SnackBarAction(
  ///     label: 'Yes',
  ///     onPressed: () => handle.complete('yes'),
  ///   ),
  ///   duration: Duration.zero, // Persistent until user responds
  /// );
  /// ```
  static SnackbarHandle showAsync<T>(
    String message, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 4),
    Color? backgroundColor,
    Color? textColor,
    Widget? iconLeft,
    Widget? iconRight,
    SnackBarAction? action,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? elevation,
    ShapeBorder? shape,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    double? width,
    DismissDirection dismissDirection = DismissDirection.down,
    bool showCloseIcon = false,
    Color? closeIconColor,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    instance._ensureInitialized();

    final handle = SnackbarHandle.async(id: id, tag: tag);

    // Build content widget with icons
    Widget content = instance._buildSnackbarContent(
      message: message,
      textColor: textColor ?? Colors.white,
      iconLeft: iconLeft,
      iconRight: iconRight,
    );

    instance._controller!.show(
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
  /// - [message]: The text message to display
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
  ///   'Delete this item?',
  ///   actionLabel: 'DELETE',
  ///   actionValue: true,
  ///   backgroundColor: Colors.red,
  /// );
  ///
  /// if (result == true) {
  ///   print('User confirmed deletion');
  /// }
  /// ```
  static Future<T?> actionAsync<T>(
    String message, {
    required String actionLabel,
    required T actionValue,
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 6),
    Color? backgroundColor,
    Color? textColor,
    Color? actionTextColor,
    Widget? iconLeft,
    Widget? iconRight,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    double? elevation,
    ShapeBorder? shape,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    double? width,
    DismissDirection dismissDirection = DismissDirection.down,
    bool showCloseIcon = false,
    Color? closeIconColor,
    RouteTransitionsBuilder? transitionsBuilder,
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
      message,
      id: snackbarId,
      tag: tag,
      duration: duration,
      backgroundColor: backgroundColor,
      textColor: textColor,
      iconLeft: iconLeft,
      iconRight: iconRight,
      action: action,
      margin: margin,
      padding: padding,
      elevation: elevation,
      shape: shape,
      behavior: behavior,
      width: width,
      dismissDirection: dismissDirection,
      showCloseIcon: showCloseIcon,
      closeIconColor: closeIconColor,
      transitionsBuilder: transitionsBuilder,
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
  Widget _buildSnackbarContent({
    required String message,
    Color? textColor,
    Widget? iconLeft,
    Widget? iconRight,
  }) {
    List<Widget> children = [];

    if (iconLeft != null) {
      children.add(iconLeft);
      children.add(const SizedBox(width: 8));
    }

    children.add(Expanded(
      child: Text(
        message,
        style: TextStyle(color: textColor),
      ),
    ));

    if (iconRight != null) {
      children.add(const SizedBox(width: 8));
      children.add(iconRight);
    }

    // NEW: Make icons follow the same color as text
    return IconTheme.merge(
      data: IconThemeData(color: textColor),
      child: Row(children: children),
    );
  }
}

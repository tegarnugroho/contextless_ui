import 'dart:async';
import 'package:flutter/material.dart';

import 'dialog_controller.dart';
import 'dialog_handle.dart';

/// Main static API for contextless dialogs.
class ContextlessDialogs {
  static DialogController? _controller;

  /// Private constructor to prevent instantiation.
  ContextlessDialogs._();

  /// Initializes the contextless dialogs system.
  ///
  /// Either [navigatorKey] or [overlayKey] must be provided.
  /// If [navigatorKey] is provided, the overlay will be obtained from it.
  ///
  /// Example:
  /// ```dart
  /// final navigatorKey = GlobalKey<NavigatorState>();
  /// ContextlessDialogs.init(navigatorKey: navigatorKey);
  /// ```
  static void init({
    GlobalKey<NavigatorState>? navigatorKey,
    GlobalKey<OverlayState>? overlayKey,
  }) {
    _controller = DialogController();
    _controller!.init(
      navigatorKey: navigatorKey,
      overlayKey: overlayKey,
    );
  }

  /// Whether the system has been initialized.
  static bool get isInitialized => _controller?.isInitialized ?? false;

  /// Shows a dialog without requiring a BuildContext.
  ///
  /// Returns a [DialogHandle] that can be used to close the dialog later.
  ///
  /// Parameters:
  /// - [dialog]: The widget to display as a dialog
  /// - [id]: Optional custom ID for the dialog (UUID generated if not provided)
  /// - [tag]: Optional tag for grouping dialogs
  /// - [barrierDismissible]: Whether tapping outside closes the dialog
  /// - [barrierColor]: Color of the barrier behind the dialog
  /// - [transitionDuration]: Duration of the show/hide animation
  /// - [transitionsBuilder]: Custom transition animation builder
  ///
  /// Example:
  /// ```dart
  /// final handle = ContextlessDialogs.show(
  ///   Dialog(
  ///     child: Text('Hello World!'),
  ///   ),
  ///   tag: 'info',
  /// );
  /// ```
  static DialogHandle show(
    Widget dialog, {
    String? id,
    String? tag,
    bool barrierDismissible = true,
    Color? barrierColor,
    Duration? transitionDuration,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    _ensureInitialized();
    return _controller!.show(
      dialog,
      id: id,
      tag: tag,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      transitionsBuilder: transitionsBuilder,
    );
  }

  /// Shows a dialog and returns a Future that completes when the dialog is closed.
  ///
  /// The Future completes with the result passed to the close methods,
  /// or null if the dialog is dismissed by tapping the barrier.
  ///
  /// Example:
  /// ```dart
  /// final result = await ContextlessDialogs.showAsync<String>(
  ///   _ColorPickerDialog(),
  ///   tag: 'picker',
  /// );
  /// if (result != null) {
  ///   // Use the selected color
  /// }
  /// ```
  static Future<T?> showAsync<T>(
    Widget dialog, {
    String? id,
    String? tag,
    bool barrierDismissible = true,
    Color? barrierColor,
    Duration? transitionDuration,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    _ensureInitialized();
    return _controller!.showAsync<T>(
      dialog,
      id: id,
      tag: tag,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      transitionsBuilder: transitionsBuilder,
    );
  }

  /// Closes a specific dialog by its handle.
  ///
  /// Returns true if the dialog was found and closed, false otherwise.
  ///
  /// Example:
  /// ```dart
  /// final handle = ContextlessDialogs.show(myDialog);
  /// // Later...
  /// ContextlessDialogs.close(handle);
  /// ```
  static bool close(DialogHandle handle, [dynamic result]) {
    _ensureInitialized();
    return _controller!.close(handle, result);
  }

  /// Closes a specific dialog by its ID.
  ///
  /// Returns true if the dialog was found and closed, false otherwise.
  ///
  /// Example:
  /// ```dart
  /// ContextlessDialogs.show(myDialog, id: 'my-dialog');
  /// // Later...
  /// ContextlessDialogs.closeById('my-dialog');
  /// ```
  static bool closeById(String id, [dynamic result]) {
    _ensureInitialized();
    return _controller!.closeById(id, result);
  }

  /// Closes all dialogs with the specified tag.
  ///
  /// Returns the number of dialogs that were closed.
  ///
  /// Example:
  /// ```dart
  /// ContextlessDialogs.show(dialog1, tag: 'progress');
  /// ContextlessDialogs.show(dialog2, tag: 'progress');
  /// // Later...
  /// final count = ContextlessDialogs.closeByTag('progress'); // Returns 2
  /// ```
  static int closeByTag(String tag, [dynamic result]) {
    _ensureInitialized();
    return _controller!.closeByTag(tag, result);
  }

  /// Closes all currently open dialogs.
  ///
  /// Example:
  /// ```dart
  /// ContextlessDialogs.closeAll();
  /// ```
  static void closeAll([dynamic result]) {
    _ensureInitialized();
    _controller!.closeAll(result);
  }

  /// Checks if a dialog is currently open.
  ///
  /// Accepts either a [DialogHandle] or a [String] ID.
  ///
  /// Example:
  /// ```dart
  /// final handle = ContextlessDialogs.show(myDialog);
  /// if (ContextlessDialogs.isOpen(handle)) {
  ///   print('Dialog is still open');
  /// }
  ///
  /// // Or by ID:
  /// if (ContextlessDialogs.isOpen('my-dialog-id')) {
  ///   print('Dialog is still open');
  /// }
  /// ```
  static bool isOpen(Object handleOrId) {
    if (!isInitialized) return false;
    return _controller!.isOpen(handleOrId);
  }

  /// Stream of dialog events (opened/closed).
  ///
  /// Listen to this stream to react to dialog lifecycle changes.
  ///
  /// Example:
  /// ```dart
  /// ContextlessDialogs.events.listen((event) {
  ///   if (event.type == DialogEventType.opened) {
  ///     print('Dialog ${event.handle.id} opened');
  ///   } else {
  ///     print('Dialog ${event.handle.id} closed with result: ${event.result}');
  ///   }
  /// });
  /// ```
  static Stream<DialogEvent> get events {
    _ensureInitialized();
    return _controller!.events;
  }

  /// Gets all currently open dialog handles.
  ///
  /// Useful for debugging or advanced use cases.
  static List<DialogHandle> get openDialogs {
    if (!isInitialized) return [];
    return _controller!.openDialogs;
  }

  /// Gets the count of currently open dialogs.
  static int get openDialogCount {
    if (!isInitialized) return 0;
    return _controller!.openDialogCount;
  }

  /// Disposes the contextless dialogs system and closes all dialogs.
  ///
  /// This should typically be called when the app is shutting down.
  /// After calling dispose, you'll need to call init again before using the system.
  static void dispose() {
    _controller?.dispose();
    _controller = null;
  }

  static void _ensureInitialized() {
    if (_controller == null) {
      throw StateError(
        'ContextlessDialogs not initialized. Call ContextlessDialogs.init() first.',
      );
    }
    if (!_controller!.isInitialized) {
      throw StateError(
        'ContextlessDialogs not properly initialized. '
        'Make sure to provide a valid navigatorKey or overlayKey.',
      );
    }
  }
}

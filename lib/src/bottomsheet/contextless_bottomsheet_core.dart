import 'dart:async';
import 'package:flutter/material.dart';

import 'bottomsheet_controller.dart';
import 'bottomsheet_handle.dart';

/// Main static API for contextless bottom sheets.
class ContextlessBottomSheets {
  static BottomSheetController? _controller;

  /// Private constructor to prevent instantiation.
  ContextlessBottomSheets._();

  /// Initializes the contextless bottom sheets system.
  ///
  /// Either [navigatorKey] or [overlayKey] must be provided.
  /// If [navigatorKey] is provided, the overlay will be obtained from it.
  ///
  /// Example:
  /// ```dart
  /// final navigatorKey = GlobalKey<NavigatorState>();
  /// ContextlessBottomSheets.init(navigatorKey: navigatorKey);
  /// ```
  static void init({
    GlobalKey<NavigatorState>? navigatorKey,
    GlobalKey<OverlayState>? overlayKey,
  }) {
    _controller = BottomSheetController();
    _controller!.init(
      navigatorKey: navigatorKey,
      overlayKey: overlayKey,
    );
  }

  /// Whether the system has been initialized.
  static bool get isInitialized => _controller?.isInitialized ?? false;

  /// Shows a bottom sheet without requiring a BuildContext.
  ///
  /// Returns a [BottomSheetHandle] that can be used to close the bottom sheet later.
  ///
  /// Parameters:
  /// - [content]: The widget to display as a bottom sheet
  /// - [id]: Optional custom ID for the bottom sheet (UUID generated if not provided)
  /// - [tag]: Optional tag for grouping bottom sheets
  /// - [isDismissible]: Whether tapping outside closes the bottom sheet
  /// - [enableDrag]: Whether the bottom sheet can be dragged to close
  /// - [backgroundColor]: Background color of the bottom sheet
  /// - [elevation]: Elevation of the bottom sheet
  /// - [shape]: Shape border for the bottom sheet
  /// - [constraints]: Size constraints for the bottom sheet
  /// - [transitionsBuilder]: Custom transition animation builder
  ///
  /// Example:
  /// ```dart
  /// final handle = ContextlessBottomSheets.show(
  ///   Container(
  ///     height: 200,
  ///     padding: EdgeInsets.all(16),
  ///     child: Column(
  ///       children: [
  ///         Text('Bottom Sheet Content'),
  ///         ElevatedButton(
  ///           onPressed: () => handle.close(),
  ///           child: Text('Close'),
  ///         ),
  ///       ],
  ///     ),
  ///   ),
  ///   isDismissible: true,
  ///   shape: RoundedRectangleBorder(
  ///     borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  ///   ),
  /// );
  /// ```
  static BottomSheetHandle show(
    Widget content, {
    String? id,
    String? tag,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    BoxConstraints? constraints,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    _ensureInitialized();
    return _controller!.showBottomSheet(
      content,
      id: id,
      tag: tag,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      constraints: constraints,
      transitionsBuilder: transitionsBuilder,
    );
  }

  /// Creates an async bottom sheet that returns a result when closed.
  ///
  /// Similar to [show] but returns a [BottomSheetHandle] that can wait for
  /// a result using the [BottomSheetHandle.result] method.
  ///
  /// Example:
  /// ```dart
  /// final handle = ContextlessBottomSheets.showAsync<String>(
  ///   MyBottomSheetWidget(
  ///     onResult: (result) => handle.complete(result),
  ///   ),
  /// );
  /// 
  /// final result = await handle.result<String>();
  /// print('Bottom sheet result: $result');
  /// ```
  static BottomSheetHandle showAsync<T>(
    Widget content, {
    String? id,
    String? tag,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    BoxConstraints? constraints,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    _ensureInitialized();
    
    final handle = BottomSheetHandle.async(id: id, tag: tag);
    
    _controller!.show(
      content,
      id: handle.id,
      tag: tag,
      options: {
        'isDismissible': isDismissible,
        'enableDrag': enableDrag,
        'backgroundColor': backgroundColor,
        'elevation': elevation,
        'shape': shape,
        'constraints': constraints,
        'transitionsBuilder': transitionsBuilder,
      },
    );
    
    return handle;
  }

  /// Closes a specific bottom sheet by its handle.
  ///
  /// Returns true if the bottom sheet was found and closed, false otherwise.
  ///
  /// Example:
  /// ```dart
  /// final handle = ContextlessBottomSheets.show(myBottomSheet);
  /// // Later...
  /// final closed = await ContextlessBottomSheets.close(handle);
  /// ```
  static Future<bool> close(BottomSheetHandle handle) async {
    if (_controller == null) return false;
    return await _controller!.close(handle);
  }

  /// Closes a bottom sheet by its ID.
  ///
  /// Returns true if a bottom sheet with the given ID was found and closed.
  ///
  /// Example:
  /// ```dart
  /// ContextlessBottomSheets.show(myBottomSheet, id: 'my-bottom-sheet');
  /// // Later...
  /// final closed = await ContextlessBottomSheets.closeById('my-bottom-sheet');
  /// ```
  static Future<bool> closeById(String id) async {
    if (_controller == null) return false;
    return await _controller!.closeById(id);
  }

  /// Closes all bottom sheets with a specific tag.
  ///
  /// Returns the number of bottom sheets that were closed.
  ///
  /// Example:
  /// ```dart
  /// ContextlessBottomSheets.show(sheet1, tag: 'settings');
  /// ContextlessBottomSheets.show(sheet2, tag: 'settings');
  /// // Later...
  /// final count = await ContextlessBottomSheets.closeByTag('settings'); // Returns 2
  /// ```
  static Future<int> closeByTag(String tag) async {
    if (_controller == null) return 0;
    return await _controller!.closeByTag(tag);
  }

  /// Closes all currently active bottom sheets.
  ///
  /// Returns the number of bottom sheets that were closed.
  ///
  /// Example:
  /// ```dart
  /// final count = await ContextlessBottomSheets.closeAll();
  /// print('Closed $count bottom sheets');
  /// ```
  static Future<int> closeAll() async {
    if (_controller == null) return 0;
    return await _controller!.closeAll();
  }

  /// Gets all currently active bottom sheet handles.
  ///
  /// This can be useful for inspecting or managing active bottom sheets.
  ///
  /// Example:
  /// ```dart
  /// final activeSheets = ContextlessBottomSheets.getActiveHandles();
  /// print('Currently showing ${activeSheets.length} bottom sheets');
  /// ```
  static List<BottomSheetHandle> getActiveHandles() {
    if (_controller == null) return [];
    return _controller!.activeHandles;
  }

  /// Gets a specific bottom sheet handle by its ID.
  ///
  /// Returns null if no bottom sheet with the given ID is currently active.
  ///
  /// Example:
  /// ```dart
  /// final handle = ContextlessBottomSheets.getById('my-bottom-sheet');
  /// if (handle != null) {
  ///   print('Bottom sheet is still active');
  /// }
  /// ```
  static BottomSheetHandle? getById(String id) {
    if (_controller == null) return null;
    return _controller!.getById(id);
  }

  /// Gets all bottom sheet handles with a specific tag.
  ///
  /// Example:
  /// ```dart
  /// final settingsSheets = ContextlessBottomSheets.getByTag('settings');
  /// print('${settingsSheets.length} settings bottom sheets active');
  /// ```
  static List<BottomSheetHandle> getByTag(String tag) {
    if (_controller == null) return [];
    return _controller!.getByTag(tag);
  }

  /// Checks if a bottom sheet with the given ID is currently active.
  ///
  /// Example:
  /// ```dart
  /// if (ContextlessBottomSheets.isActive('my-bottom-sheet')) {
  ///   print('Bottom sheet is still showing');
  /// }
  /// ```
  static bool isActive(String id) {
    if (_controller == null) return false;
    return _controller!.overlayManager?.isActive(id) ?? false;
  }

  /// Gets the count of currently active bottom sheets.
  ///
  /// Example:
  /// ```dart
  /// final count = ContextlessBottomSheets.getActiveCount();
  /// print('Currently showing $count bottom sheets');
  /// ```
  static int getActiveCount() {
    if (_controller == null) return 0;
    return _controller!.overlayManager?.activeCount ?? 0;
  }

  /// Disposes the bottom sheet system and closes all active bottom sheets.
  ///
  /// This should be called when shutting down the application
  /// or when you no longer need the bottom sheet system.
  ///
  /// Example:
  /// ```dart
  /// ContextlessBottomSheets.dispose();
  /// ```
  static void dispose() {
    _controller?.dispose();
    _controller = null;
  }

  /// Ensures the system is initialized before use.
  static void _ensureInitialized() {
    if (!isInitialized) {
      throw StateError(
        'ContextlessBottomSheets not initialized. Call ContextlessBottomSheets.init() first.',
      );
    }
  }
}

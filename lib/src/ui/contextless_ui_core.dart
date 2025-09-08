import 'dart:async';
import 'package:flutter/material.dart';

import 'ui_controller.dart';
import 'ui_handle.dart';
import '../dialogs/contextless_dialogs_core.dart';

/// Main static API for contextless UI components.
/// 
/// This extends contextless dialogs to include snackbars, bottom sheets, 
/// toasts, and other UI components that don't require BuildContext.
class ContextlessUi {
  static UiController? _controller;
  
  /// Private constructor to prevent instantiation.
  ContextlessUi._();
  
  /// Initializes the contextless UI system.
  /// This also initializes ContextlessDialogs if not already initialized.
  /// 
  /// Either [navigatorKey] or [overlayKey] must be provided.
  /// If [navigatorKey] is provided, the overlay will be obtained from it.
  /// 
  /// Example:
  /// ```dart
  /// final navigatorKey = GlobalKey<NavigatorState>();
  /// ContextlessUi.init(navigatorKey: navigatorKey);
  /// ```
  static void init({
    GlobalKey<NavigatorState>? navigatorKey,
    GlobalKey<OverlayState>? overlayKey,
  }) {
    // Initialize the UI controller
    _controller = UiController();
    _controller!.init(
      navigatorKey: navigatorKey,
      overlayKey: overlayKey,
    );
    
    // Also initialize ContextlessDialogs if not already initialized
    if (!ContextlessDialogs.isInitialized) {
      ContextlessDialogs.init(
        navigatorKey: navigatorKey,
        overlayKey: overlayKey,
      );
    }
  }
  
  /// Whether the system has been initialized.
  static bool get isInitialized => _controller?.isInitialized ?? false;

  // SNACKBAR METHODS

  /// Shows a snackbar without requiring a BuildContext.
  /// 
  /// Returns a [UiHandle] that can be used to close the snackbar later.
  /// 
  /// Example:
  /// ```dart
  /// final handle = ContextlessUi.showSnackbar(
  ///   Text('Hello World!'),
  ///   duration: Duration(seconds: 3),
  /// );
  /// ```
  static UiHandle showSnackbar(
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

  /// Shows a snackbar and returns a Future that completes when dismissed.
  /// 
  /// Example:
  /// ```dart
  /// await ContextlessUi.showSnackbarAsync<String>(
  ///   Text('Select an option'),
  ///   action: SnackBarAction(
  ///     label: 'OK',
  ///     onPressed: () => ContextlessUi.closeByTag('selection', 'ok'),
  ///   ),
  ///   tag: 'selection',
  /// );
  /// ```
  static Future<T?> showSnackbarAsync<T>(
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
    return _controller!.showSnackbarAsync<T>(
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

  // BOTTOM SHEET METHODS

  /// Shows a bottom sheet without requiring a BuildContext.
  /// 
  /// Returns a [UiHandle] that can be used to close the bottom sheet later.
  /// 
  /// Example:
  /// ```dart
  /// final handle = ContextlessUi.showBottomSheet(
  ///   Container(
  ///     height: 200,
  ///     child: Text('Bottom Sheet Content'),
  ///   ),
  /// );
  /// ```
  static UiHandle showBottomSheet(
    Widget content, {
    String? id,
    String? tag,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
    Offset? anchorPoint,
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
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
      transitionsBuilder: transitionsBuilder,
    );
  }

  /// Shows a bottom sheet and returns a Future that completes when dismissed.
  /// 
  /// Example:
  /// ```dart
  /// final result = await ContextlessUi.showBottomSheetAsync<String>(
  ///   _ColorPicker(),
  ///   tag: 'color-picker',
  /// );
  /// ```
  static Future<T?> showBottomSheetAsync<T>(
    Widget content, {
    String? id,
    String? tag,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    RouteSettings? routeSettings,
    AnimationController? transitionAnimationController,
    Offset? anchorPoint,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    _ensureInitialized();
    return _controller!.showBottomSheetAsync<T>(
      content,
      id: id,
      tag: tag,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
      transitionsBuilder: transitionsBuilder,
    );
  }

  // TOAST METHODS

  /// Shows a toast notification without requiring a BuildContext.
  /// 
  /// Returns a [UiHandle] that can be used to close the toast later.
  /// 
  /// Example:
  /// ```dart
  /// final handle = ContextlessUi.showToast(
  ///   Container(
  ///     padding: EdgeInsets.all(16),
  ///     decoration: BoxDecoration(
  ///       color: Colors.black87,
  ///       borderRadius: BorderRadius.circular(8),
  ///     ),
  ///     child: Text('Toast message', style: TextStyle(color: Colors.white)),
  ///   ),
  /// );
  /// ```
  static UiHandle showToast(
    Widget content, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
    EdgeInsetsGeometry? margin,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    _ensureInitialized();
    return _controller!.showToast(
      content,
      id: id,
      tag: tag,
      duration: duration,
      alignment: alignment,
      margin: margin,
      transitionsBuilder: transitionsBuilder,
    );
  }

  /// Shows a toast and returns a Future that completes when dismissed.
  /// 
  /// Example:
  /// ```dart
  /// await ContextlessUi.showToastAsync(
  ///   Text('Processing...'),
  ///   duration: Duration(seconds: 2),
  /// );
  /// ```
  static Future<T?> showToastAsync<T>(
    Widget content, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
    EdgeInsetsGeometry? margin,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    _ensureInitialized();
    return _controller!.showToastAsync<T>(
      content,
      id: id,
      tag: tag,
      duration: duration,
      alignment: alignment,
      margin: margin,
      transitionsBuilder: transitionsBuilder,
    );
  }

  // CONTROL METHODS

  /// Closes a UI component by its handle.
  /// 
  /// Returns true if the component was found and closed, false otherwise.
  /// 
  /// Example:
  /// ```dart
  /// final handle = ContextlessUi.showSnackbar(Text('Hello'));
  /// // Later...
  /// ContextlessUi.close(handle);
  /// ```
  static bool close(UiHandle handle, [dynamic result]) {
    _ensureInitialized();
    return _controller!.close(handle, result);
  }

  /// Closes a UI component by its ID.
  /// 
  /// Returns true if the component was found and closed, false otherwise.
  /// 
  /// Example:
  /// ```dart
  /// ContextlessUi.showSnackbar(Text('Hello'), id: 'my-snackbar');
  /// // Later...
  /// ContextlessUi.closeById('my-snackbar');
  /// ```
  static bool closeById(String id, [dynamic result]) {
    _ensureInitialized();
    return _controller!.closeById(id, result);
  }

  /// Closes all UI components with the specified tag.
  /// 
  /// Returns the number of components that were closed.
  /// 
  /// Example:
  /// ```dart
  /// ContextlessUi.showSnackbar(Text('1'), tag: 'notifications');
  /// ContextlessUi.showToast(Text('2'), tag: 'notifications');
  /// // Later...
  /// final count = ContextlessUi.closeByTag('notifications'); // Returns 2
  /// ```
  static int closeByTag(String tag, [dynamic result]) {
    _ensureInitialized();
    return _controller!.closeByTag(tag, result);
  }

  /// Closes all UI components of a specific type.
  /// 
  /// Returns the number of components that were closed.
  /// 
  /// Example:
  /// ```dart
  /// final count = ContextlessUi.closeByType(UiType.snackbar);
  /// ```
  static int closeByType(UiType type, [dynamic result]) {
    _ensureInitialized();
    return _controller!.closeByType(type, result);
  }

  /// Closes all currently open UI components.
  /// 
  /// Example:
  /// ```dart
  /// ContextlessUi.closeAll();
  /// ```
  static void closeAll([dynamic result]) {
    _ensureInitialized();
    _controller!.closeAll(result);
  }

  // QUERY METHODS

  /// Checks if a UI component is currently open.
  /// 
  /// Accepts either a [UiHandle] or a [String] ID.
  /// 
  /// Example:
  /// ```dart
  /// final handle = ContextlessUi.showSnackbar(Text('Hello'));
  /// if (ContextlessUi.isOpen(handle)) {
  ///   print('Snackbar is still open');
  /// }
  /// 
  /// // Or by ID:
  /// if (ContextlessUi.isOpen('my-component-id')) {
  ///   print('Component is still open');
  /// }
  /// ```
  static bool isOpen(Object handleOrId) {
    if (!isInitialized) return false;
    return _controller!.isOpen(handleOrId);
  }

  /// Gets all currently open UI component handles.
  /// 
  /// Useful for debugging or advanced use cases.
  static List<UiHandle> get openUiComponents {
    if (!isInitialized) return [];
    return _controller!.openUiComponents;
  }

  /// Gets the count of currently open UI components.
  static int get openUiComponentCount {
    if (!isInitialized) return 0;
    return _controller!.openUiComponentCount;
  }

  /// Stream of UI component events (opened/closed).
  /// 
  /// Listen to this stream to react to UI component lifecycle changes.
  /// 
  /// Example:
  /// ```dart
  /// ContextlessUi.events.listen((event) {
  ///   if (event.type == UiEventType.opened) {
  ///     print('${event.handle.type} ${event.handle.id} opened');
  ///   } else {
  ///     print('${event.handle.type} ${event.handle.id} closed with result: ${event.result}');
  ///   }
  /// });
  /// ```
  static Stream<UiEvent> get events {
    _ensureInitialized();
    return _controller!.events;
  }

  /// Disposes the contextless UI system and closes all components.
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
        'ContextlessUi not initialized. Call ContextlessUi.init() first.',
      );
    }
    if (!_controller!.isInitialized) {
      throw StateError(
        'ContextlessUi not properly initialized. '
        'Make sure to provide a valid navigatorKey or overlayKey.',
      );
    }
  }
}

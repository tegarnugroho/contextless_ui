import 'dart:async';
import 'package:flutter/material.dart';

import 'ui_handle.dart';
import 'ui_overlay_manager.dart';

/// Controller for managing UI components without requiring BuildContext
class UiController {
  UiOverlayManager? _overlayManager;
  late StreamController<UiEvent> _eventController;
  
  bool get isInitialized => _overlayManager?.isInitialized ?? false;

  /// Initializes the UI controller
  void init({
    GlobalKey<NavigatorState>? navigatorKey,
    GlobalKey<OverlayState>? overlayKey,
  }) {
    _overlayManager = UiOverlayManager();
    _overlayManager!.init(
      navigatorKey: navigatorKey,
      overlayKey: overlayKey,
    );
    _eventController = StreamController<UiEvent>.broadcast();
  }

  /// Shows a snackbar without requiring BuildContext
  UiHandle showSnackbar(
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
    final handle = UiHandle(id: id, tag: tag, type: UiType.snackbar);
    
    _overlayManager!.showSnackbar(
      handle: handle,
      content: content,
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
      onDismissed: () => _handleClosed(handle, null),
    );
    
    _eventController.add(UiEvent(
      handle: handle,
      type: UiEventType.opened,
    ));
    
    return handle;
  }

  /// Shows a bottom sheet without requiring BuildContext
  UiHandle showBottomSheet(
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
    final handle = UiHandle(id: id, tag: tag, type: UiType.bottomSheet);
    
    _overlayManager!.showBottomSheet(
      handle: handle,
      content: content,
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
      onDismissed: () => _handleClosed(handle, null),
    );
    
    _eventController.add(UiEvent(
      handle: handle,
      type: UiEventType.opened,
    ));
    
    return handle;
  }

  /// Shows a toast notification without requiring BuildContext
  UiHandle showToast(
    Widget content, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
    EdgeInsetsGeometry? margin,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    final handle = UiHandle(id: id, tag: tag, type: UiType.toast);
    
    _overlayManager!.showToast(
      handle: handle,
      content: content,
      duration: duration,
      alignment: alignment,
      margin: margin,
      transitionsBuilder: transitionsBuilder,
      onDismissed: () => _handleClosed(handle, null),
    );
    
    _eventController.add(UiEvent(
      handle: handle,
      type: UiEventType.opened,
    ));
    
    return handle;
  }

  /// Shows a snackbar and returns a Future that completes when dismissed
  Future<T?> showSnackbarAsync<T>(
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
    final handle = UiHandle.async(id: id, tag: tag, type: UiType.snackbar);
    
    _overlayManager!.showSnackbar(
      handle: handle,
      content: content,
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
      onDismissed: () => _handleClosed(handle, null),
    );
    
    _eventController.add(UiEvent(
      handle: handle,
      type: UiEventType.opened,
    ));
    
    return handle.future<T>();
  }

  /// Shows a bottom sheet and returns a Future that completes when dismissed
  Future<T?> showBottomSheetAsync<T>(
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
    final handle = UiHandle.async(id: id, tag: tag, type: UiType.bottomSheet);
    
    _overlayManager!.showBottomSheet(
      handle: handle,
      content: content,
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
      onDismissed: () => _handleClosed(handle, null),
    );
    
    _eventController.add(UiEvent(
      handle: handle,
      type: UiEventType.opened,
    ));
    
    return handle.future<T>();
  }

  /// Shows a toast and returns a Future that completes when dismissed
  Future<T?> showToastAsync<T>(
    Widget content, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
    EdgeInsetsGeometry? margin,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    final handle = UiHandle.async(id: id, tag: tag, type: UiType.toast);
    
    _overlayManager!.showToast(
      handle: handle,
      content: content,
      duration: duration,
      alignment: alignment,
      margin: margin,
      transitionsBuilder: transitionsBuilder,
      onDismissed: () => _handleClosed(handle, null),
    );
    
    _eventController.add(UiEvent(
      handle: handle,
      type: UiEventType.opened,
    ));
    
    return handle.future<T>();
  }

  /// Closes a UI component by its handle
  bool close(UiHandle handle, [dynamic result]) {
    final success = result != null 
        ? _overlayManager!.removeUiComponentWithResult(handle.id, result)
        : _overlayManager!.removeUiComponent(handle.id);
    if (success) {
      _handleClosed(handle, result);
    }
    return success;
  }

  /// Closes a UI component by its ID
  bool closeById(String id, [dynamic result]) {
    final handle = _overlayManager!.getUiHandle(id);
    if (handle != null) {
      return close(handle, result);
    }
    return false;
  }

  /// Closes all UI components with the specified tag
  int closeByTag(String tag, [dynamic result]) {
    final handles = _overlayManager!.getUiHandlesByTag(tag);
    int count = 0;
    for (final handle in handles) {
      if (close(handle, result)) {
        count++;
      }
    }
    return count;
  }

  /// Closes all UI components of a specific type
  int closeByType(UiType type, [dynamic result]) {
    final handles = _overlayManager!.getUiHandlesByType(type);
    int count = 0;
    for (final handle in handles) {
      if (close(handle, result)) {
        count++;
      }
    }
    return count;
  }

  /// Closes all currently open UI components
  void closeAll([dynamic result]) {
    final handles = List<UiHandle>.from(_overlayManager!.openUiHandles);
    for (final handle in handles) {
      close(handle, result);
    }
  }

  /// Checks if a UI component is currently open
  bool isOpen(Object handleOrId) {
    if (handleOrId is UiHandle) {
      return _overlayManager!.isUiComponentOpen(handleOrId.id);
    } else if (handleOrId is String) {
      return _overlayManager!.isUiComponentOpen(handleOrId);
    }
    return false;
  }

  /// Gets all currently open UI handles
  List<UiHandle> get openUiComponents => _overlayManager?.openUiHandles ?? [];

  /// Gets the count of currently open UI components
  int get openUiComponentCount => _overlayManager?.openUiComponentCount ?? 0;

  /// Stream of UI events
  Stream<UiEvent> get events => _eventController.stream;

  /// Disposes the controller and closes all UI components
  void dispose() {
    closeAll();
    _overlayManager?.dispose();
    _overlayManager = null;
    _eventController.close();
  }

  void _handleClosed(UiHandle handle, dynamic result) {
    if (handle.isAsync && !handle.isCompleted) {
      handle.complete(result);
    }
    
    _eventController.add(UiEvent(
      handle: handle,
      type: UiEventType.closed,
      result: result,
    ));
  }
}

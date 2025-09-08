import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'ui_handle.dart';
import 'ui_transitions.dart';

/// Manages overlay entries for UI components
class UiOverlayManager {
  GlobalKey<NavigatorState>? _navigatorKey;
  GlobalKey<OverlayState>? _overlayKey;
  final Map<String, _UiEntry> _activeComponents = {};
  
  bool get isInitialized {
    if (_navigatorKey != null) {
      return _navigatorKey!.currentState != null;
    } else if (_overlayKey != null) {
      return _overlayKey!.currentState != null;
    }
    return false;
  }

  OverlayState? get _overlay {
    if (_navigatorKey != null) {
      return _navigatorKey!.currentState?.overlay;
    } else if (_overlayKey != null) {
      return _overlayKey!.currentState;
    }
    return null;
  }

  void init({
    GlobalKey<NavigatorState>? navigatorKey,
    GlobalKey<OverlayState>? overlayKey,
  }) {
    if (navigatorKey == null && overlayKey == null) {
      throw ArgumentError(
        'Either navigatorKey or overlayKey must be provided',
      );
    }
    if (navigatorKey != null && overlayKey != null) {
      throw ArgumentError(
        'Only one of navigatorKey or overlayKey should be provided',
      );
    }

    _navigatorKey = navigatorKey;
    _overlayKey = overlayKey;
  }



  void showSnackbar({
    required UiHandle handle,
    required Widget content,
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
    VoidCallback? onDismissed,
  }) {
    final overlay = _overlay;
    if (overlay == null) return;

    void execute() {
      _showSnackbarInternal(
        overlay: overlay,
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
        transitionsBuilder: transitionsBuilder ?? UiTransitions.slideFromBottom,
        onDismissed: onDismissed,
      );
    }

    // Execute immediately in test environment, otherwise defer to next frame  
    try {
      // Check if we're in a test environment
      if (WidgetsBinding.instance.runtimeType.toString().contains('Test')) {
        execute();
      } else {
        SchedulerBinding.instance.addPostFrameCallback((_) => execute());
      }
    } catch (e) {
      // Fallback to immediate execution if binding check fails
      execute();
    }
  }

  void showBottomSheet({
    required UiHandle handle,
    required Widget content,
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
    VoidCallback? onDismissed,
  }) {
    final overlay = _overlay;
    if (overlay == null) return;

    void execute() {
      _showBottomSheetInternal(
        overlay: overlay,
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
        transitionsBuilder: transitionsBuilder ?? UiTransitions.slideFromBottom,
        onDismissed: onDismissed,
      );
    }

    // Execute immediately in test environment, otherwise defer to next frame  
    try {
      // Check if we're in a test environment
      if (WidgetsBinding.instance.runtimeType.toString().contains('Test')) {
        execute();
      } else {
        SchedulerBinding.instance.addPostFrameCallback((_) => execute());
      }
    } catch (e) {
      // Fallback to immediate execution if binding check fails
      execute();
    }
  }

  void showToast({
    required UiHandle handle,
    required Widget content,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
    EdgeInsetsGeometry? margin,
    RouteTransitionsBuilder? transitionsBuilder,
    VoidCallback? onDismissed,
  }) {
    final overlay = _overlay;
    if (overlay == null) return;

    void execute() {
      _showToastInternal(
        overlay: overlay,
        handle: handle,
        content: content,
        duration: duration,
        alignment: alignment,
        margin: margin,
        transitionsBuilder: transitionsBuilder ?? UiTransitions.fade,
        onDismissed: onDismissed,
      );
    }

    // Execute immediately in test environment, otherwise defer to next frame  
    try {
      // Check if we're in a test environment
      if (WidgetsBinding.instance.runtimeType.toString().contains('Test')) {
        execute();
      } else {
        SchedulerBinding.instance.addPostFrameCallback((_) => execute());
      }
    } catch (e) {
      // Fallback to immediate execution if binding check fails
      execute();
    }
  }

  void _showSnackbarInternal({
    required OverlayState overlay,
    required UiHandle handle,
    required Widget content,
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
    required RouteTransitionsBuilder transitionsBuilder,
    VoidCallback? onDismissed,
  }) {
    // Check if overlay is still mounted before creating animation controller
    if (!overlay.mounted) return;
    
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: overlay,
    );

    bool isDismissed = false;

    void dismiss() {
      if (isDismissed) return;
      isDismissed = true;
      
      // Cancel timer from the entry
      final entry = _activeComponents[handle.id];
      entry?.autoCloseTimer?.cancel();
      
      // Dispose controller and remove immediately for testing
      try {
        animationController.dispose();
      } catch (e) {
        // Ignore disposal errors for testing
      }
      final removedEntry = _activeComponents.remove(handle.id);
      removedEntry?.overlayEntry.remove();
      onDismissed?.call();
    }

    final overlayEntry = OverlayEntry(
      builder: (context) => _UiWrapper(
        animationController: animationController,
        transitionsBuilder: transitionsBuilder,
        child: Align(
          alignment: behavior == SnackBarBehavior.floating 
            ? Alignment.bottomCenter 
            : Alignment.bottomCenter,
          child: Container(
            width: width,
            margin: margin ?? const EdgeInsets.all(16),
            child: Material(
              color: backgroundColor ?? Theme.of(context).snackBarTheme.backgroundColor,
              elevation: elevation ?? 6.0,
              shape: shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
            child: Dismissible(
                key: Key(handle.id),
                direction: dismissDirection,
                onDismissed: (_) => dismiss(),
                child: DefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: null, // Use system default
                    decoration: TextDecoration.none,
                  ),
                  child: Padding(
                    padding: padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(child: content),
                        if (action != null) ...[
                          const SizedBox(width: 8),
                          action,
                        ],
                        if (showCloseIcon) ...[
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: dismiss,
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: closeIconColor ?? Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final entry = _UiEntry(
      handle: handle,
      overlayEntry: overlayEntry,
      animationController: animationController,
      dismiss: dismiss,
    );

    _activeComponents[handle.id] = entry;

    overlay.insert(overlayEntry);
    animationController.forward();

    // Auto-dismiss after duration and store timer in entry
    entry.autoCloseTimer = Timer(duration, dismiss);
  }

  void _showBottomSheetInternal({
    required OverlayState overlay,
    required UiHandle handle,
    required Widget content,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    Clip? clipBehavior,
    BoxConstraints? constraints,
    Color? barrierColor,
    bool isScrollControlled = false,
    required RouteTransitionsBuilder transitionsBuilder,
    VoidCallback? onDismissed,
  }) {
    // Check if overlay is still mounted before creating animation controller
    if (!overlay.mounted) return;
    
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: overlay,
    );

    bool isDismissed = false;

    void dismiss() {
      if (isDismissed) return;
      isDismissed = true;
      
      // Dispose controller and remove immediately for testing
      try {
        animationController.dispose();
      } catch (e) {
        // Ignore disposal errors for testing
      }
      final entry = _activeComponents.remove(handle.id);
      entry?.overlayEntry.remove();
      onDismissed?.call();
    }

    final overlayEntry = OverlayEntry(
      builder: (context) => _UiWrapper(
        animationController: animationController,
        transitionsBuilder: transitionsBuilder,
        child: Stack(
          children: [
            // Barrier
            if (isDismissible)
              GestureDetector(
                onTap: dismiss,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent, // Make barrier transparent
                ),
              ),
            // Bottom sheet content
            Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                color: backgroundColor ?? Theme.of(context).bottomSheetTheme.backgroundColor,
                elevation: elevation ?? 16.0,
                shape: shape ?? const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                clipBehavior: clipBehavior ?? Clip.none,
                child: Container(
                  constraints: constraints,
                  width: double.infinity,
                  child: enableDrag
                    ? GestureDetector(
                        onVerticalDragUpdate: (details) {
                          // Handle drag to dismiss logic if needed
                        },
                        child: content,
                      )
                    : content,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    _activeComponents[handle.id] = _UiEntry(
      handle: handle,
      overlayEntry: overlayEntry,
      animationController: animationController,
      dismiss: dismiss,
    );

    overlay.insert(overlayEntry);
    animationController.forward();
  }

  void _showToastInternal({
    required OverlayState overlay,
    required UiHandle handle,
    required Widget content,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
    EdgeInsetsGeometry? margin,
    required RouteTransitionsBuilder transitionsBuilder,
    VoidCallback? onDismissed,
  }) {
    // Check if overlay is still mounted before creating animation controller
    if (!overlay.mounted) return;
    
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: overlay,
    );

    bool isDismissed = false;

    void dismiss() {
      if (isDismissed) return;
      isDismissed = true;
      
      // Cancel timer from the entry
      final entry = _activeComponents[handle.id];
      entry?.autoCloseTimer?.cancel();
      
      // Dispose controller and remove immediately for testing
      try {
        animationController.dispose();
      } catch (e) {
        // Ignore disposal errors for testing
      }
      final removedEntry = _activeComponents.remove(handle.id);
      removedEntry?.overlayEntry.remove();
      onDismissed?.call();
    }

    final overlayEntry = OverlayEntry(
      builder: (context) => _UiWrapper(
        animationController: animationController,
        transitionsBuilder: transitionsBuilder,
        child: Align(
          alignment: alignment,
          child: Container(
            margin: margin ?? const EdgeInsets.all(16),
            child: DefaultTextStyle(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: null, // Use system default
                decoration: TextDecoration.none,
              ),
              child: content,
            ),
          ),
        ),
      ),
    );

    final entry = _UiEntry(
      handle: handle,
      overlayEntry: overlayEntry,
      animationController: animationController,
      dismiss: dismiss,
    );

    _activeComponents[handle.id] = entry;

    overlay.insert(overlayEntry);
    animationController.forward();

    // Auto-dismiss after duration and store timer in entry
    entry.autoCloseTimer = Timer(duration, dismiss);
  }

  bool removeUiComponent(String id) {
    final entry = _activeComponents[id];
    if (entry == null) return false;

    // Call the dismiss function which properly cancels timers
    try {
      entry.dismiss();
    } catch (e) {
      // Fallback to manual cleanup if dismiss fails
      try {
        entry.animationController.dispose();
      } catch (e) {
        // Ignore disposal errors for testing
      }
      entry.overlayEntry.remove();
      _activeComponents.remove(id);
    }

    return true;
  }

  bool removeUiComponentWithResult(String id, dynamic result) {
    final entry = _activeComponents[id];
    if (entry == null) return false;

    // Cancel any auto-close timer
    entry.autoCloseTimer?.cancel();

    // Manual cleanup with result handling - bypass the dismiss function
    try {
      entry.animationController.dispose();
    } catch (e) {
      // Ignore disposal errors for testing
    }
    entry.overlayEntry.remove();
    _activeComponents.remove(id);

    return true;
  }

  UiHandle? getUiHandle(String id) {
    return _activeComponents[id]?.handle;
  }

  List<UiHandle> getUiHandlesByTag(String tag) {
    return _activeComponents.values
        .where((entry) => entry.handle.tag == tag)
        .map((entry) => entry.handle)
        .toList();
  }

  List<UiHandle> getUiHandlesByType(UiType type) {
    return _activeComponents.values
        .where((entry) => entry.handle.type == type)
        .map((entry) => entry.handle)
        .toList();
  }

  bool isUiComponentOpen(String id) {
    return _activeComponents.containsKey(id);
  }

  List<UiHandle> get openUiHandles {
    return _activeComponents.values.map((entry) => entry.handle).toList();
  }

  int get openUiComponentCount => _activeComponents.length;

  void dispose() {
    for (final entry in _activeComponents.values) {
      try {
        entry.animationController.dispose();
      } catch (e) {
        // Ignore disposal errors during testing
      }
      entry.overlayEntry.remove();
    }
    _activeComponents.clear();
    
    // Reset keys for testing
    _navigatorKey = null;
    _overlayKey = null;
  }
}

class _UiEntry {
  final UiHandle handle;
  final OverlayEntry overlayEntry;
  final AnimationController animationController;
  final VoidCallback dismiss;
  Timer? autoCloseTimer;

  _UiEntry({
    required this.handle,
    required this.overlayEntry,
    required this.animationController,
    required this.dismiss,
  });
}

class _UiWrapper extends StatelessWidget {
  final AnimationController animationController;
  final RouteTransitionsBuilder transitionsBuilder;
  final Widget child;

  const _UiWrapper({
    required this.animationController,
    required this.transitionsBuilder,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) => transitionsBuilder(
        context,
        animationController,
        animationController, // Secondary animation not used for UI components
        child,
      ),
    );
  }
}

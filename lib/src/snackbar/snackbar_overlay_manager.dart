import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../core/base_components.dart';
import 'snackbar_handle.dart';
import 'snackbar_transitions.dart';

/// Internal record for tracking snackbar entries.
class _SnackbarEntry {
  final OverlayEntry overlayEntry;
  final SnackbarHandle handle;
  final String? tag;
  final AnimationController animationController;
  final SnackBarBehavior behavior;

  _SnackbarEntry({
    required this.overlayEntry,
    required this.handle,
    required this.animationController,
    required this.behavior,
    this.tag,
  });
}

/// Manages snackbar display using Flutter's Overlay system.
class SnackbarOverlayManager extends BaseOverlayManager<SnackbarHandle> {
  final Map<String, _SnackbarEntry> _activeSnackbars = {};

  @override
  Map<String, dynamic> get activeComponents => _activeSnackbars;

  @override
  SnackbarHandle show(
    Widget content, {
    String? id,
    String? tag,
    Map<String, dynamic>? options,
  }) {
    if (!isInitialized) {
      throw StateError('SnackbarOverlayManager not initialized');
    }

    final handle = SnackbarHandle(id: id, tag: tag);
    
    // Extract options
    final duration = options?['duration'] as Duration? ?? const Duration(seconds: 4);
    final backgroundColor = options?['backgroundColor'] as Color?;
    final margin = options?['margin'] as EdgeInsetsGeometry?;
    final padding = options?['padding'] as EdgeInsetsGeometry?;
    final elevation = options?['elevation'] as double?;
    final shape = options?['shape'] as ShapeBorder?;
    final behavior = options?['behavior'] as SnackBarBehavior? ?? SnackBarBehavior.floating;
    final action = options?['action'] as SnackBarAction?;
    final width = options?['width'] as double?;
    final dismissDirection = options?['dismissDirection'] as DismissDirection? ?? DismissDirection.down;
    final showCloseIcon = options?['showCloseIcon'] as bool? ?? false;
    final closeIconColor = options?['closeIconColor'] as Color?;
    final transitionsBuilder = options?['transitionsBuilder'] as RouteTransitionsBuilder?;

    // Create animation controller
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 200),
      vsync: overlay!,
    );

    // Create overlay entry
    final overlayEntry = OverlayEntry(
      builder: (context) {
        return _SnackbarWrapper(
          animation: animationController,
          behavior: behavior,
          margin: margin,
          width: width,
          dismissDirection: dismissDirection,
          onDismiss: () => close(handle),
          transitionsBuilder: transitionsBuilder,
          child: Material(
            elevation: elevation ?? 4.0,
            color: backgroundColor ?? Theme.of(context).snackBarTheme.backgroundColor,
            shape: shape,
            child: Container(
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 14.0),
              child: Row(
                children: [
                  Expanded(child: content),
                  if (action != null) ...[
                    const SizedBox(width: 8),
                    action,
                  ],
                  if (showCloseIcon) ...[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.close, color: closeIconColor),
                      onPressed: () => close(handle),
                      iconSize: 18,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );

    // Store entry
    _activeSnackbars[handle.id] = _SnackbarEntry(
      overlayEntry: overlayEntry,
      handle: handle,
      animationController: animationController,
      behavior: behavior,
      tag: tag,
    );

    // Show snackbar
    overlay!.insert(overlayEntry);
    animationController.forward();

    // Auto-dismiss after duration
    if (duration != Duration.zero) {
      Future.delayed(duration).then((_) => close(handle));
    }

    return handle;
  }

  @override
  Future<bool> close(SnackbarHandle handle) async {
    final entry = _activeSnackbars[handle.id];
    if (entry == null) return false;

    try {
      // Animate out
      await entry.animationController.reverse();
      
      // Remove from overlay
      entry.overlayEntry.remove();
      
      // Dispose animation controller
      entry.animationController.dispose();
      
      // Remove from tracking
      _activeSnackbars.remove(handle.id);
      
      // Complete handle if async
      handle.complete();
      
      return true;
    } catch (e) {
      // Clean up even if animation fails
      try {
        entry.overlayEntry.remove();
        entry.animationController.dispose();
        _activeSnackbars.remove(handle.id);
        handle.completeError(e);
      } catch (_) {}
      return false;
    }
  }

  @override
  Future<bool> closeById(String id) async {
    final entry = _activeSnackbars[id];
    if (entry == null) return false;
    return await close(entry.handle);
  }

  @override
  Future<int> closeByTag(String tag) async {
    final entries = _activeSnackbars.values
        .where((entry) => entry.tag == tag)
        .toList();
    
    int closed = 0;
    for (final entry in entries) {
      if (await close(entry.handle)) {
        closed++;
      }
    }
    return closed;
  }

  @override
  Future<int> closeAll() async {
    final entries = _activeSnackbars.values.toList();
    int closed = 0;
    
    for (final entry in entries) {
      if (await close(entry.handle)) {
        closed++;
      }
    }
    return closed;
  }

  @override
  List<SnackbarHandle> get activeHandles {
    return _activeSnackbars.values.map((entry) => entry.handle).toList();
  }

  @override
  SnackbarHandle? getById(String id) {
    return _activeSnackbars[id]?.handle;
  }

  @override
  List<SnackbarHandle> getByTag(String tag) {
    return _activeSnackbars.values
        .where((entry) => entry.tag == tag)
        .map((entry) => entry.handle)
        .toList();
  }

  /// Closes all snackbars and disposes resources.
  void dispose() {
    final entries = _activeSnackbars.values.toList();
    for (final entry in entries) {
      try {
        entry.overlayEntry.remove();
        entry.animationController.dispose();
      } catch (_) {}
    }
    _activeSnackbars.clear();
  }
}

/// Wrapper widget for snackbar with positioning and animations.
class _SnackbarWrapper extends StatelessWidget {
  final Animation<double> animation;
  final SnackBarBehavior behavior;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final DismissDirection dismissDirection;
  final VoidCallback onDismiss;
  final Widget child;
  final RouteTransitionsBuilder? transitionsBuilder;

  const _SnackbarWrapper({
    required this.animation,
    required this.behavior,
    required this.onDismiss,
    required this.child,
    this.margin,
    this.width,
    this.dismissDirection = DismissDirection.down,
    this.transitionsBuilder,
  });

  @override
  Widget build(BuildContext context) {
    Widget snackbar = Container(
      width: width,
      margin: margin ?? (behavior == SnackBarBehavior.floating 
          ? const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0)
          : EdgeInsets.zero),
      child: child,
    );

    snackbar = SnackbarTransitions.buildTransition(
      context: context,
      animation: animation,
      child: snackbar,
      transitionsBuilder: transitionsBuilder,
    );

    if (dismissDirection != DismissDirection.none) {
      snackbar = Dismissible(
        key: ValueKey('snackbar'),
        direction: dismissDirection,
        onDismissed: (_) => onDismiss(),
        child: snackbar,
      );
    }

    return Align(
      alignment: behavior == SnackBarBehavior.floating 
          ? Alignment.bottomCenter 
          : Alignment.bottomCenter,
      child: snackbar,
    );
  }
}

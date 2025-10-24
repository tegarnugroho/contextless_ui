import 'package:flutter/material.dart';
import '../../core/base/base_components.dart';
import 'bottomsheet_handle.dart';
import 'bottomsheet_transitions.dart';

/// Internal record for tracking bottom sheet entries.
class _BottomSheetEntry {
  final OverlayEntry overlayEntry;
  final BottomSheetHandle handle;
  final String? tag;
  final AnimationController animationController;
  final bool isDismissible;

  _BottomSheetEntry({
    required this.overlayEntry,
    required this.handle,
    required this.animationController,
    required this.isDismissible,
    this.tag,
  });
}

/// Manages bottom sheet display using Flutter's Overlay system.
class BottomSheetOverlayManager extends BaseOverlayManager<BottomSheetHandle> {
  final Map<String, _BottomSheetEntry> _activeBottomSheets = {};

  @override
  Map<String, dynamic> get activeComponents => _activeBottomSheets;

  @override
  BottomSheetHandle show(
    Widget content, {
    String? id,
    String? tag,
    Map<String, dynamic>? options,
  }) {
    if (!isInitialized) {
      throw StateError('BottomSheetOverlayManager not initialized');
    }

    final handle = BottomSheetHandle(id: id, tag: tag);
    
    // Extract options
    final isDismissible = options?['isDismissible'] as bool? ?? true;
    final backgroundColor = options?['backgroundColor'] as Color?;
    final shape = options?['shape'] as ShapeBorder?;
    final constraints = options?['constraints'] as BoxConstraints?;
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
        return _BottomSheetWrapper(
          animation: animationController,
          isDismissible: isDismissible,
          onDismiss: () => close(handle),
          transitionsBuilder: transitionsBuilder,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              constraints: constraints,
              decoration: BoxDecoration(
                color: backgroundColor ?? Theme.of(context).bottomSheetTheme.backgroundColor,
                borderRadius: shape is RoundedRectangleBorder 
                    ? (shape).borderRadius
                    : null,
              ),
              child: content,
            ),
          ),
        );
      },
    );

    // Store entry
    _activeBottomSheets[handle.id] = _BottomSheetEntry(
      overlayEntry: overlayEntry,
      handle: handle,
      animationController: animationController,
      isDismissible: isDismissible,
      tag: tag,
    );

    // Show bottom sheet
    overlay!.insert(overlayEntry);
    animationController.forward();

    return handle;
  }

  @override
  Future<bool> close(BottomSheetHandle handle) async {
    final entry = _activeBottomSheets[handle.id];
    if (entry == null) return false;

    try {
      // Animate out
      await entry.animationController.reverse();
      
      // Remove from overlay
      entry.overlayEntry.remove();
      
      // Dispose animation controller
      entry.animationController.dispose();
      
      // Remove from tracking
      _activeBottomSheets.remove(handle.id);
      
      // Complete handle if async
      handle.complete();
      
      return true;
    } catch (e) {
      // Clean up even if animation fails
      try {
        entry.overlayEntry.remove();
        entry.animationController.dispose();
        _activeBottomSheets.remove(handle.id);
        handle.completeError(e);
      } catch (_) {}
      return false;
    }
  }

  @override
  Future<bool> closeById(String id) async {
    final entry = _activeBottomSheets[id];
    if (entry == null) return false;
    return await close(entry.handle);
  }

  @override
  Future<int> closeByTag(String tag) async {
    final entries = _activeBottomSheets.values
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
    final entries = _activeBottomSheets.values.toList();
    int closed = 0;
    
    for (final entry in entries) {
      if (await close(entry.handle)) {
        closed++;
      }
    }
    return closed;
  }

  @override
  List<BottomSheetHandle> get activeHandles {
    return _activeBottomSheets.values.map((entry) => entry.handle).toList();
  }

  @override
  BottomSheetHandle? getById(String id) {
    return _activeBottomSheets[id]?.handle;
  }

  @override
  List<BottomSheetHandle> getByTag(String tag) {
    return _activeBottomSheets.values
        .where((entry) => entry.tag == tag)
        .map((entry) => entry.handle)
        .toList();
  }

  /// Closes all bottom sheets and disposes resources.
  void dispose() {
    final entries = _activeBottomSheets.values.toList();
    for (final entry in entries) {
      try {
        entry.overlayEntry.remove();
        entry.animationController.dispose();
      } catch (_) {}
    }
    _activeBottomSheets.clear();
  }
}

/// Wrapper widget for bottom sheet with barrier and animations.
class _BottomSheetWrapper extends StatelessWidget {
  final Animation<double> animation;
  final bool isDismissible;
  final VoidCallback onDismiss;
  final Widget child;
  final RouteTransitionsBuilder? transitionsBuilder;

  const _BottomSheetWrapper({
    required this.animation,
    required this.isDismissible,
    required this.onDismiss,
    required this.child,
    this.transitionsBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDismissible ? onDismiss : null,
      child: Container(
        color: Colors.black.withValues(alpha: 0.5 * animation.value),
        child: GestureDetector(
          onTap: () {}, // Prevent taps on the bottom sheet from dismissing
          child: Align(
            alignment: Alignment.bottomCenter,
            child: BottomSheetTransitions.buildTransition(
              context: context,
              animation: animation,
              child: child,
              transitionsBuilder: transitionsBuilder,
            ),
          ),
        ),
      ),
    );
  }
}

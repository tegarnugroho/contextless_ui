import 'package:flutter/material.dart';
import '../core/base/base_components.dart';
import 'toast_handle.dart';
import 'toast_transitions.dart';

/// Internal record for tracking toast entries.
class _ToastEntry {
  final OverlayEntry overlayEntry;
  final ToastHandle handle;
  final String? tag;
  final AnimationController animationController;
  final Alignment alignment;

  _ToastEntry({
    required this.overlayEntry,
    required this.handle,
    required this.animationController,
    required this.alignment,
    this.tag,
  });
}

/// Manages toast display using Flutter's Overlay system.
class ToastOverlayManager extends BaseOverlayManager<ToastHandle> {
  final Map<String, _ToastEntry> _activeToasts = {};

  @override
  Map<String, dynamic> get activeComponents => _activeToasts;

  @override
  ToastHandle show(
    Widget content, {
    String? id,
    String? tag,
    Map<String, dynamic>? options,
  }) {
    if (!isInitialized) {
      throw StateError('ToastOverlayManager not initialized');
    }

    final handle = ToastHandle(id: id, tag: tag);
    
    // Extract options
    final duration = options?['duration'] as Duration? ?? const Duration(seconds: 3);
    final alignment = options?['alignment'] as Alignment? ?? Alignment.bottomCenter;
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
        return ToastTransitions.buildTransition(
          context: context,
          animation: animationController,
          child: Align(
            alignment: alignment,
            child: Material(
              type: MaterialType.transparency,
              child: content,
            ),
          ),
          transitionsBuilder: transitionsBuilder,
        );
      },
    );

    // Store entry
    _activeToasts[handle.id] = _ToastEntry(
      overlayEntry: overlayEntry,
      handle: handle,
      animationController: animationController,
      alignment: alignment,
      tag: tag,
    );

    // Show toast
    overlay!.insert(overlayEntry);
    animationController.forward();

    // Auto-dismiss after duration
    if (duration != Duration.zero) {
      Future.delayed(duration).then((_) => close(handle));
    }

    return handle;
  }

  @override
  Future<bool> close(ToastHandle handle) async {
    final entry = _activeToasts[handle.id];
    if (entry == null) return false;

    try {
      // Animate out
      await entry.animationController.reverse();
      
      // Remove from overlay
      entry.overlayEntry.remove();
      
      // Dispose animation controller
      entry.animationController.dispose();
      
      // Remove from tracking
      _activeToasts.remove(handle.id);
      
      // Complete handle if async
      handle.complete();
      
      return true;
    } catch (e) {
      // Clean up even if animation fails
      try {
        entry.overlayEntry.remove();
        entry.animationController.dispose();
        _activeToasts.remove(handle.id);
        handle.completeError(e);
      } catch (_) {}
      return false;
    }
  }

  @override
  Future<bool> closeById(String id) async {
    final entry = _activeToasts[id];
    if (entry == null) return false;
    return await close(entry.handle);
  }

  @override
  Future<int> closeByTag(String tag) async {
    final entries = _activeToasts.values
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
    final entries = _activeToasts.values.toList();
    int closed = 0;
    
    for (final entry in entries) {
      if (await close(entry.handle)) {
        closed++;
      }
    }
    return closed;
  }

  @override
  List<ToastHandle> get activeHandles {
    return _activeToasts.values.map((entry) => entry.handle).toList();
  }

  @override
  ToastHandle? getById(String id) {
    return _activeToasts[id]?.handle;
  }

  @override
  List<ToastHandle> getByTag(String tag) {
    return _activeToasts.values
        .where((entry) => entry.tag == tag)
        .map((entry) => entry.handle)
        .toList();
  }

  /// Closes all toasts and disposes resources.
  void dispose() {
    final entries = _activeToasts.values.toList();
    for (final entry in entries) {
      try {
        entry.overlayEntry.remove();
        entry.animationController.dispose();
      } catch (_) {}
    }
    _activeToasts.clear();
  }
}

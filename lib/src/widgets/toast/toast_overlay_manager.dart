import 'package:flutter/material.dart';
import '../../core/base/base_components.dart';
import 'toast_handle.dart';
import 'toast_transitions.dart';

/// Internal record for tracking toast entries.
class _ToastEntry {
  final OverlayEntry overlayEntry;
  final ToastHandle handle;
  final String? tag;
  final AnimationController animationController;
  final Alignment alignment;
  final ValueNotifier<Widget> contentNotifier;

  _ToastEntry({
    required this.overlayEntry,
    required this.handle,
    required this.animationController,
    required this.alignment,
    required this.contentNotifier,
    this.tag,
  });

  void dispose() {
    contentNotifier.dispose();
    animationController.dispose();
  }
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
    final duration =
        options?['duration'] as Duration? ?? const Duration(seconds: 3);
    final alignment =
        options?['alignment'] as Alignment? ?? Alignment.bottomCenter;
    final transitionsBuilder =
        options?['transitionsBuilder'] as RouteTransitionsBuilder?;

    // If toast with same ID exists, update its content instead of recreating
    final existingEntry = _activeToasts[handle.id];
    if (existingEntry != null) {
      // Update the content without recreating the overlay entry
      existingEntry.contentNotifier.value = content;
      return existingEntry.handle;
    }

    // Create content notifier for dynamic updates
    final contentNotifier = ValueNotifier<Widget>(content);

    // Create animation controller
    final animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 200),
      vsync: overlay!,
    );

    // Create overlay entry with ValueListenableBuilder for dynamic content
    final overlayEntry = OverlayEntry(
      builder: (context) {
        return ValueListenableBuilder<Widget>(
          valueListenable: contentNotifier,
          builder: (context, currentContent, child) {
            return ToastTransitions.buildTransition(
              context: context,
              animation: animationController,
              child: Align(
                alignment: alignment,
                child: Material(
                  type: MaterialType.transparency,
                  child: currentContent,
                ),
              ),
              transitionsBuilder: transitionsBuilder,
            );
          },
        );
      },
    );

    // Store entry
    _activeToasts[handle.id] = _ToastEntry(
      overlayEntry: overlayEntry,
      handle: handle,
      animationController: animationController,
      alignment: alignment,
      contentNotifier: contentNotifier,
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

      // Dispose resources
      entry.dispose();

      // Remove from tracking
      _activeToasts.remove(handle.id);

      // Complete handle if async
      handle.complete();

      return true;
    } catch (e) {
      // Clean up even if animation fails
      try {
        entry.overlayEntry.remove();
        entry.dispose();
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
    final entries =
        _activeToasts.values.where((entry) => entry.tag == tag).toList();

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
        entry.dispose();
      } catch (_) {}
    }
    _activeToasts.clear();
  }
}

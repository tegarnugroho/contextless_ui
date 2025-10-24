import 'package:flutter/material.dart';
import '../../core/base/base_components.dart';
import 'dialog_handle.dart';
import 'dialog_transitions.dart';

/// Internal record for tracking dialog entries.
class _DialogEntry {
  final OverlayEntry overlayEntry;
  final DialogHandle handle;
  final AnimationController animationController;

  _DialogEntry({
    required this.overlayEntry,
    required this.handle,
    required this.animationController,
  });
}

/// Manages dialog display using Flutter's Overlay system.
class DialogOverlayManager extends BaseOverlayManager<DialogHandle> {
  final Map<String, _DialogEntry> _activeDialogs = {};

  @override
  DialogHandle show(
    Widget content, {
    String? id,
    String? tag,
    Map<String, dynamic>? options,
  }) {
    if (!isInitialized) {
      throw StateError('DialogOverlayManager not initialized. Call init() first.');
    }

    final handle = DialogHandle(id: id, tag: tag);
    
    final barrierDismissible = options?['barrierDismissible'] ?? true;
    final barrierColor = options?['barrierColor'];
    final transitionDuration = options?['transitionDuration'] ?? const Duration(milliseconds: 200);
    final transitionsBuilder = options?['transitionsBuilder'];

    _showDialog(
      content,
      handle: handle,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      transitionsBuilder: transitionsBuilder,
    );

    activeComponents[handle.id] = handle;
    return handle;
  }

  /// Shows a dialog asynchronously.
  Future<void> showDialogAsync(
    Widget content, {
    required DialogHandle handle,
    bool barrierDismissible = true,
    Color? barrierColor,
    Duration? transitionDuration,
    RouteTransitionsBuilder? transitionsBuilder,
  }) async {
    if (!isInitialized) {
      throw StateError('DialogOverlayManager not initialized. Call init() first.');
    }

    _showDialog(
      content,
      handle: handle,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration ?? const Duration(milliseconds: 200),
      transitionsBuilder: transitionsBuilder,
    );

    activeComponents[handle.id] = handle;
  }

  void _showDialog(
    Widget content, {
    required DialogHandle handle,
    bool barrierDismissible = true,
    Color? barrierColor,
    Duration? transitionDuration,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    final animationController = AnimationController(
      duration: transitionDuration ?? const Duration(milliseconds: 200),
      vsync: overlay!,
    );

    final overlayEntry = OverlayEntry(
      builder: (context) => _buildDialogOverlay(
        content,
        handle: handle,
        animationController: animationController,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        transitionsBuilder: transitionsBuilder,
      ),
    );

    final entry = _DialogEntry(
      overlayEntry: overlayEntry,
      handle: handle,
      animationController: animationController,
    );

    _activeDialogs[handle.id] = entry;
    overlay!.insert(overlayEntry);

    // Start animation
    animationController.forward();
  }

  Widget _buildDialogOverlay(
    Widget content, {
    required DialogHandle handle,
    required AnimationController animationController,
    bool barrierDismissible = true,
    Color? barrierColor,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          // Barrier
          GestureDetector(
            onTap: barrierDismissible ? () => close(handle) : null,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: barrierColor ?? Colors.black54,
            ),
          ),
          // Dialog content
          Center(
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                if (transitionsBuilder != null) {
                  return transitionsBuilder(
                    context,
                    animationController,
                    animationController,
                    content,
                  );
                } else {
                  return DialogTransitions.defaultTransition(
                    context,
                    animationController,
                    null,
                    content,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<bool> close(DialogHandle handle) {
    return closeById(handle.id);
  }

  @override
  Future<bool> closeById(String id) async {
    final entry = _activeDialogs[id];
    if (entry == null) return false;

    // Animate out
    await entry.animationController.reverse();

    // Remove from overlay
    entry.overlayEntry.remove();
    entry.animationController.dispose();

    // Clean up
    _activeDialogs.remove(id);
    activeComponents.remove(id);

    // Complete async handles
    if (entry.handle.completer != null && !entry.handle.completer!.isCompleted) {
      entry.handle.complete(null);
    }

    return true;
  }

  @override
  Future<int> closeByTag(String tag) async {
    final handlesToClose = _activeDialogs.values
        .where((entry) => entry.handle.tag == tag)
        .toList();

    int closedCount = 0;
    for (final entry in handlesToClose) {
      final success = await closeById(entry.handle.id);
      if (success) closedCount++;
    }

    return closedCount;
  }

  @override
  Future<int> closeAll() async {
    final allHandles = _activeDialogs.keys.toList();
    
    int closedCount = 0;
    for (final id in allHandles) {
      final success = await closeById(id);
      if (success) closedCount++;
    }

    return closedCount;
  }

  @override
  List<DialogHandle> get activeHandles {
    return _activeDialogs.values.map((entry) => entry.handle).toList();
  }

  @override
  DialogHandle? getById(String id) {
    return _activeDialogs[id]?.handle;
  }

  @override
  List<DialogHandle> getByTag(String tag) {
    return _activeDialogs.values
        .where((entry) => entry.handle.tag == tag)
        .map((entry) => entry.handle)
        .toList();
  }

  /// Disposes all resources.
  void dispose() {
    for (final entry in _activeDialogs.values) {
      entry.overlayEntry.remove();
      entry.animationController.dispose();
    }
    _activeDialogs.clear();
    activeComponents.clear();
  }
}

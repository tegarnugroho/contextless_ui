import 'package:flutter/material.dart';
import '../core/base/base_components.dart';
import 'toast_handle.dart';
import 'toast_overlay_manager.dart';

/// Controller for managing toast operations.
class ToastController extends BaseController<ToastHandle> {
  @override
  BaseOverlayManager<ToastHandle> createOverlayManager() {
    return ToastOverlayManager();
  }

  /// Shows a toast with the specified options.
  ToastHandle showToast(
    Widget content, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 3),
    Alignment alignment = Alignment.bottomCenter,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    return show(
      content,
      id: id,
      tag: tag,
      options: {
        'duration': duration,
        'alignment': alignment,
        'transitionsBuilder': transitionsBuilder,
      },
    );
  }

  /// Disposes the controller and all active toasts.
  void dispose() {
    if (overlayManager is ToastOverlayManager) {
      (overlayManager as ToastOverlayManager).dispose();
    }
  }
}

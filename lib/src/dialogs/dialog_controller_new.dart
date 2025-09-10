import 'package:flutter/material.dart';
import '../core/base/base_components.dart';
import 'dialog_handle.dart';
import 'dialog_overlay_manager.dart';

/// Controller for managing dialog operations.
class DialogController extends BaseController<DialogHandle> {
  @override
  BaseOverlayManager<DialogHandle> createOverlayManager() {
    return DialogOverlayManager();
  }

  /// Shows a dialog with the specified options.
  DialogHandle showDialog(
    Widget dialog, {
    String? id,
    String? tag,
    bool barrierDismissible = true,
    Color? barrierColor,
    Duration? transitionDuration,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    return show(
      dialog,
      id: id,
      tag: tag,
      options: {
        'barrierDismissible': barrierDismissible,
        'barrierColor': barrierColor,
        'transitionDuration': transitionDuration,
        'transitionsBuilder': transitionsBuilder,
      },
    );
  }

  /// Shows a dialog asynchronously with the specified options.
  Future<T?> showDialogAsync<T>(
    Widget dialog, {
    String? id,
    String? tag,
    bool barrierDismissible = true,
    Color? barrierColor,
    Duration? transitionDuration,
    RouteTransitionsBuilder? transitionsBuilder,
  }) async {
    final handle = DialogHandle.async(id: id, tag: tag);
    
    if (overlayManager is DialogOverlayManager) {
      await (overlayManager as DialogOverlayManager).showDialogAsync(
        dialog,
        handle: handle,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        transitionDuration: transitionDuration,
        transitionsBuilder: transitionsBuilder,
      );
    }
    
    return await handle.result<T>();
  }

  /// Disposes the controller and all active dialogs.
  void dispose() {
    if (overlayManager is DialogOverlayManager) {
      (overlayManager as DialogOverlayManager).dispose();
    }
  }
}

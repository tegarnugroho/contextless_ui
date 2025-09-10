import 'package:flutter/material.dart';
import '../core/base/base_components.dart';
import 'snackbar_handle.dart';
import 'snackbar_overlay_manager.dart';

/// Controller for managing snackbar operations.
class SnackbarController extends BaseController<SnackbarHandle> {
  @override
  BaseOverlayManager<SnackbarHandle> createOverlayManager() {
    return SnackbarOverlayManager();
  }

  /// Shows a snackbar with the specified options.
  SnackbarHandle showSnackbar(
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
    return show(
      content,
      id: id,
      tag: tag,
      options: {
        'duration': duration,
        'backgroundColor': backgroundColor,
        'margin': margin,
        'padding': padding,
        'elevation': elevation,
        'shape': shape,
        'behavior': behavior,
        'action': action,
        'width': width,
        'dismissDirection': dismissDirection,
        'showCloseIcon': showCloseIcon,
        'closeIconColor': closeIconColor,
        'transitionsBuilder': transitionsBuilder,
      },
    );
  }

  /// Disposes the controller and all active snackbars.
  void dispose() {
    if (overlayManager is SnackbarOverlayManager) {
      (overlayManager as SnackbarOverlayManager).dispose();
    }
  }
}

import 'package:flutter/material.dart';
import '../core/base/base_components.dart';
import 'bottomsheet_handle.dart';
import 'bottomsheet_overlay_manager.dart';

/// Controller for managing bottom sheet operations.
class BottomSheetController extends BaseController<BottomSheetHandle> {
  @override
  BaseOverlayManager<BottomSheetHandle> createOverlayManager() {
    return BottomSheetOverlayManager();
  }

  /// Shows a bottom sheet with the specified options.
  BottomSheetHandle showBottomSheet(
    Widget content, {
    String? id,
    String? tag,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    BoxConstraints? constraints,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    return show(
      content,
      id: id,
      tag: tag,
      options: {
        'isDismissible': isDismissible,
        'enableDrag': enableDrag,
        'backgroundColor': backgroundColor,
        'elevation': elevation,
        'shape': shape,
        'constraints': constraints,
        'transitionsBuilder': transitionsBuilder,
      },
    );
  }

  /// Disposes the controller and all active bottom sheets.
  void dispose() {
    if (overlayManager is BottomSheetOverlayManager) {
      (overlayManager as BottomSheetOverlayManager).dispose();
    }
  }
}

import 'package:flutter/material.dart';

/// Model for bottom sheet visual decoration properties.
class BottomSheetDecoration {
  /// Background color of the bottom sheet
  final Color? backgroundColor;

  /// Elevation of the bottom sheet
  final double? elevation;

  /// Shape border for the bottom sheet
  final ShapeBorder? shape;

  /// Size constraints for the bottom sheet
  final BoxConstraints? constraints;

  /// Custom transition animation builder
  final RouteTransitionsBuilder? transitionsBuilder;

  const BottomSheetDecoration({
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.constraints,
    this.transitionsBuilder,
  });
}

import 'package:flutter/material.dart';

/// Model for toast visual decoration properties.
class ToastDecoration {
  /// Background color of the toast
  final Color? backgroundColor;

  /// Padding inside the toast
  final EdgeInsetsGeometry? padding;

  /// Border radius for the toast
  final BorderRadius? borderRadius;

  /// Elevation of the toast
  final double? elevation;

  /// Custom transition animation builder
  final RouteTransitionsBuilder? transitionsBuilder;

  const ToastDecoration({
    this.backgroundColor,
    this.padding,
    this.borderRadius,
    this.elevation,
    this.transitionsBuilder,
  });
}

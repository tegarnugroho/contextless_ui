import 'package:flutter/material.dart';

/// Model for snackbar visual decoration properties.
class SnackbarDecoration {
  /// Background color of the snackbar
  final Color? backgroundColor;

  /// Margin around the snackbar
  final EdgeInsetsGeometry? margin;

  /// Padding inside the snackbar
  final EdgeInsetsGeometry? padding;

  /// Elevation of the snackbar
  final double? elevation;

  /// Shape border for the snackbar
  final ShapeBorder? shape;

  /// Width of the snackbar
  final double? width;

  /// Whether the snackbar is floating or fixed
  final SnackBarBehavior behavior;

  /// Direction for swipe-to-dismiss
  final DismissDirection dismissDirection;

  /// Whether to show a close icon
  final bool showCloseIcon;

  /// Color of the close icon
  final Color? closeIconColor;

  /// Custom transition animation builder
  final RouteTransitionsBuilder? transitionsBuilder;

  const SnackbarDecoration({
    this.backgroundColor,
    this.margin,
    this.padding,
    this.elevation,
    this.shape,
    this.width,
    this.behavior = SnackBarBehavior.floating,
    this.dismissDirection = DismissDirection.down,
    this.showCloseIcon = false,
    this.closeIconColor,
    this.transitionsBuilder,
  });
}

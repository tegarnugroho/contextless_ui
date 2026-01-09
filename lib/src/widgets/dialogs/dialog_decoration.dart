import 'package:flutter/material.dart';

/// Model for dialog visual decoration properties.
class DialogDecoration {
  /// Color of the barrier behind the dialog
  final Color? barrierColor;

  /// Duration of the show/hide animation
  final Duration? transitionDuration;

  /// Custom transition animation builder
  final RouteTransitionsBuilder? transitionsBuilder;

  const DialogDecoration({
    this.barrierColor,
    this.transitionDuration,
    this.transitionsBuilder,
  });
}

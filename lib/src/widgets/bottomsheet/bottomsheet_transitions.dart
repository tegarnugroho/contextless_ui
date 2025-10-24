import 'package:flutter/material.dart';

/// Provides transition animations for bottom sheets.
class BottomSheetTransitions {
  BottomSheetTransitions._();

  /// Builds transition animation for a bottom sheet.
  static Widget buildTransition({
    required BuildContext context,
    required Animation<double> animation,
    required Widget child,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    if (transitionsBuilder != null) {
      return transitionsBuilder(
        context,
        animation,
        const AlwaysStoppedAnimation(0.0),
        child,
      );
    }

    return slideUp(
      context: context,
      animation: animation,
      child: child,
    );
  }

  /// Slide up transition for bottom sheets.
  static Widget slideUp({
    required BuildContext context,
    required Animation<double> animation,
    required Widget child,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      )),
      child: child,
    );
  }

  /// Fade transition for bottom sheets.
  static Widget fade({
    required BuildContext context,
    required Animation<double> animation,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  /// Scale transition for bottom sheets.
  static Widget scale({
    required BuildContext context,
    required Animation<double> animation,
    required Widget child,
  }) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.9,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      )),
      child: child,
    );
  }

  /// Slide and fade combination.
  static Widget slideAndFade({
    required BuildContext context,
    required Animation<double> animation,
    required Widget child,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

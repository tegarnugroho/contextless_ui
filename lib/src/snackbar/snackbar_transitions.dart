import 'package:flutter/material.dart';

/// Provides transition animations for snackbars.
class SnackbarTransitions {
  SnackbarTransitions._();

  /// Builds transition animation for a snackbar.
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

  /// Slide up transition for snackbars.
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
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  /// Slide down transition for snackbars.
  static Widget slideDown({
    required BuildContext context,
    required Animation<double> animation,
    required Widget child,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, -1.0),
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

  /// Fade transition for snackbars.
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

  /// Scale transition for snackbars.
  static Widget scale({
    required BuildContext context,
    required Animation<double> animation,
    required Widget child,
  }) {
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.8,
        end: 1.0,
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

  /// Slide from left transition.
  static Widget slideFromLeft({
    required BuildContext context,
    required Animation<double> animation,
    required Widget child,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
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

  /// Slide from right transition.
  static Widget slideFromRight({
    required BuildContext context,
    required Animation<double> animation,
    required Widget child,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0),
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

import 'package:flutter/material.dart';
import '../../contextless_ui_unified_core.dart';

/// A [NavigatorObserver] that automatically initializes ContextlessUi
/// when the first route is pushed. This is the most convenient approach
/// for existing apps - just add it to your MaterialApp's navigatorObservers.
///
/// Example:
/// ```dart
/// class MyApp extends StatelessWidget {
///   final navigatorKey = GlobalKey<NavigatorState>();
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       navigatorKey: navigatorKey,
///       navigatorObservers: [
///         ContextlessObserver(),
///       ],
///       home: MyHomePage(),
///     );
///   }
/// }
/// ```
class ContextlessObserver extends NavigatorObserver {
  bool _inited = false;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    if (_inited) return;

    final nav = navigator;
    if (nav != null) {
      // Try to get the navigatorKey from the navigator widget
      GlobalKey<NavigatorState>? navKey;
      if (nav.widget.key is GlobalKey<NavigatorState>) {
        navKey = nav.widget.key as GlobalKey<NavigatorState>;
      }

      // Initialize ContextlessUi with the navigator's overlay
      ContextlessUi.init(
        navigatorKey: navKey,
        overlayKey: nav.overlay != null ? GlobalKey<OverlayState>() : null,
      );

      _inited = true;
    }
  }

  /// Manually reset the initialization state.
  /// Useful for testing or if you need to reinitialize.
  void reset() {
    _inited = false;
  }
}

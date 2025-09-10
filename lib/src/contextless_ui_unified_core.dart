import 'package:flutter/material.dart';

import 'bottomsheet/bottomsheet.dart';
import 'dialogs/dialogs.dart';
import 'snackbar/snackbar.dart';
import 'toast/toast.dart';

/// Unified core that initializes all contextless UI subsystems.
///
/// This class serves as the central initialization point for the contextless UI library.
/// After initialization, use each subsystem directly via their static classes.
///
/// Example usage:
/// ```dart
/// // Initialize all subsystems at once
/// ContextlessUi.init(navigatorKey: navigatorKey);
///
/// // Use subsystems directly via their static classes
/// ContextlessDialogs.show(myDialog);
/// ContextlessToasts.show(myToast);
/// ContextlessBottomSheets.show(myBottomSheet);
/// ContextlessSnackbars.show(mySnackbar);
///
/// // Global operations via unified core
/// final totalActive = ContextlessUi.getTotalActiveCount();
/// final closedCount = await ContextlessUi.closeAll();
/// ```
class ContextlessUi {
  /// Private constructor to prevent instantiation.
  ContextlessUi._();

  static ContextlessDialogs get dialog => ContextlessDialogs.instance;

  static ContextlessSnackbars get snackbar => ContextlessSnackbars.instance;

  static ContextlessToasts get toast => ContextlessToasts.instance;

  static ContextlessBottomSheets get bottomSheet =>
      ContextlessBottomSheets.instance;

  /// Initializes all contextless UI subsystems.
  ///
  /// Either [navigatorKey] or [overlayKey] must be provided.
  /// If [navigatorKey] is provided, the overlay will be obtained from it.
  ///
  /// This will initialize:
  /// - ContextlessDialogs
  /// - ContextlessToasts
  /// - ContextlessBottomSheets
  /// - ContextlessSnackbars
  ///
  /// Example:
  /// ```dart
  /// final navigatorKey = GlobalKey<NavigatorState>();
  /// ContextlessUi.init(navigatorKey: navigatorKey);
  /// ```
  static void init({
    GlobalKey<NavigatorState>? navigatorKey,
    GlobalKey<OverlayState>? overlayKey,
  }) {
    // Initialize all subsystems
    dialog.init(
      navigatorKey: navigatorKey,
      overlayKey: overlayKey,
    );

    toast.init(
      navigatorKey: navigatorKey,
      overlayKey: overlayKey,
    );

    bottomSheet.init(
      navigatorKey: navigatorKey,
      overlayKey: overlayKey,
    );

    snackbar.init(
      navigatorKey: navigatorKey,
      overlayKey: overlayKey,
    );
  }
}

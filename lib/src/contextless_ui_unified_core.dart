import 'package:flutter/material.dart';

import 'dialogs/contextless_dialogs_core.dart';
import 'toast/contextless_toast_core.dart';
import 'bottomsheet/contextless_bottomsheet_core.dart';
import 'snackbar/contextless_snackbar_core.dart';

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
  static bool _isInitialized = false;
  
  /// Private constructor to prevent instantiation.
  ContextlessUi._();

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
    ContextlessDialogs.init(
      navigatorKey: navigatorKey,
      overlayKey: overlayKey,
    );
    
    ContextlessToasts.init(
      navigatorKey: navigatorKey,
      overlayKey: overlayKey,
    );
    
    ContextlessBottomSheets.init(
      navigatorKey: navigatorKey,
      overlayKey: overlayKey,
    );
    
    ContextlessSnackbars.init(
      navigatorKey: navigatorKey,
      overlayKey: overlayKey,
    );
    
    _isInitialized = true;
  }

  /// Whether all subsystems have been initialized.
  static bool get isInitialized => _isInitialized &&
      ContextlessDialogs.isInitialized &&
      ContextlessToasts.isInitialized &&
      ContextlessBottomSheets.isInitialized &&
      ContextlessSnackbars.isInitialized;

  /// Gets the total count of active components across all subsystems.
  static int getTotalActiveCount() {
    if (!_isInitialized) return 0;
    
    return ContextlessDialogs.openDialogCount +
           ContextlessToasts.getActiveCount() +
           ContextlessBottomSheets.getActiveCount() +
           ContextlessSnackbars.getActiveCount();
  }

  /// Gets the count of active components by type.
  ///
  /// Returns a map with keys: 'dialogs', 'toasts', 'bottomSheets', 'snackbars'
  static Map<String, int> getActiveCountsByType() {
    if (!_isInitialized) {
      return {
        'dialogs': 0,
        'toasts': 0,
        'bottomSheets': 0,
        'snackbars': 0,
      };
    }
    
    return {
      'dialogs': ContextlessDialogs.openDialogCount,
      'toasts': ContextlessToasts.getActiveCount(),
      'bottomSheets': ContextlessBottomSheets.getActiveCount(),
      'snackbars': ContextlessSnackbars.getActiveCount(),
    };
  }

  /// Closes all active components across all subsystems.
  ///
  /// Returns the total number of components that were closed.
  static Future<int> closeAll([dynamic result]) async {
    if (!_isInitialized) return 0;
    
    final initialCount = getTotalActiveCount();
    
    // Close all components in all subsystems
    ContextlessDialogs.closeAll(result);
    await ContextlessToasts.closeAll();
    await ContextlessBottomSheets.closeAll();
    await ContextlessSnackbars.closeAll();
    
    return initialCount;
  }

  /// Disposes all subsystems.
  ///
  /// This should typically be called when the app is shutting down.
  /// After calling dispose, you'll need to call init again before using any subsystem.
  static void dispose() {
    ContextlessDialogs.dispose();
    ContextlessToasts.dispose();
    ContextlessBottomSheets.dispose();
    ContextlessSnackbars.dispose();
    _isInitialized = false;
  }
}

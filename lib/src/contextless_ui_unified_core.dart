import 'package:flutter/material.dart';

import 'widgets/bottomsheet/bottomsheet.dart';
import 'widgets/dialogs/dialogs.dart';
import 'widgets/snackbar/snackbar.dart';
import 'widgets/toast/toast.dart';
import 'widgets/snackbar/snackbar_decoration.dart';
import 'widgets/toast/toast_decoration.dart';
import 'widgets/dialogs/dialog_decoration.dart';
import 'widgets/bottomsheet/bottomsheet_decoration.dart';

/// Unified core that initializes all contextless UI subsystems.
///
/// This class provides a unified API for all UI components (dialogs, snackbars, toasts, bottom sheets).
/// All UI operations should be performed through the static methods provided by this class.
///
/// Example usage:
/// ```dart
/// // Initialize all subsystems at once
/// ContextlessUi.init(navigatorKey: navigatorKey);
///
/// // Show UI components using the unified API
/// ContextlessUi.showDialog(myDialog);
/// ContextlessUi.showSnackbar(Text('Hello'));
/// ContextlessUi.showToast(Text('Toast message'));
/// ContextlessUi.showBottomSheet(myBottomSheet);
///
/// // Close all components
/// await ContextlessUi.closeAll();
/// ```
class ContextlessUi {
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
    ContextlessDialogs.instance.init(
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
  }

  // ============================================================================
  // Dialog Methods
  // ============================================================================

  /// Shows a dialog without requiring a BuildContext.
  static DialogHandle showDialog(
    Widget dialog, {
    String? id,
    String? tag,
    bool barrierDismissible = true,
    DialogDecoration? decoration,
  }) {
    return ContextlessDialogs.instance.show(
      dialog,
      id: id,
      tag: tag,
      barrierDismissible: barrierDismissible,
      decoration: decoration,
    );
  }

  /// Shows a dialog and returns a Future that completes when closed.
  static Future<T?> showDialogAsync<T>(
    Widget dialog, {
    String? id,
    String? tag,
    bool barrierDismissible = true,
    DialogDecoration? decoration,
  }) {
    return ContextlessDialogs.instance.showAsync<T>(
      dialog,
      id: id,
      tag: tag,
      barrierDismissible: barrierDismissible,
      decoration: decoration,
    );
  }

  /// Closes a specific dialog by its handle.
  static Future<bool> closeDialog(DialogHandle handle, [dynamic result]) {
    return ContextlessDialogs.instance.close(handle, result);
  }

  /// Closes a dialog by its ID.
  static Future<bool> closeDialogById(String id, [dynamic result]) {
    return ContextlessDialogs.instance.closeById(id, result);
  }

  /// Closes all dialogs with a specific tag.
  static Future<int> closeDialogsByTag(String tag, [dynamic result]) {
    return ContextlessDialogs.instance.closeByTag(tag, result);
  }

  /// Closes all currently active dialogs.
  static Future<int> closeAllDialogs([dynamic result]) {
    return ContextlessDialogs.instance.closeAll(result);
  }

  // ============================================================================
  // Snackbar Methods
  // ============================================================================

  /// Shows a snackbar without requiring a BuildContext.
  static SnackbarHandle showSnackbar(
    Widget content, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 4),
    Widget? action,
    SnackbarDecoration? decoration,
    Widget? iconLeft,
    Widget? iconRight,
  }) {
    return ContextlessSnackbars.show(
      content,
      id: id,
      tag: tag,
      duration: duration,
      action: action,
      decoration: decoration,
      iconLeft: iconLeft,
      iconRight: iconRight,
    );
  }

  /// Shows an async snackbar that returns a result when closed.
  static SnackbarHandle showSnackbarAsync<T>(
    Widget content, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 4),
    Widget? action,
    SnackbarDecoration? decoration,
    Widget? iconLeft,
    Widget? iconRight,
  }) {
    return ContextlessSnackbars.showAsync<T>(
      content,
      id: id,
      tag: tag,
      duration: duration,
      action: action,
      decoration: decoration,
      iconLeft: iconLeft,
      iconRight: iconRight,
    );
  }

  /// Shows an async snackbar with an action button that returns a value when pressed.
  static Future<T?> showSnackbarWithAction<T>(
    Widget content, {
    required Widget Function(VoidCallback onPressed) action,
    required T actionValue,
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 6),
    SnackbarDecoration? decoration,
    Widget? iconLeft,
    Widget? iconRight,
  }) {
    return ContextlessSnackbars.actionAsync<T>(
      content,
      action: action,
      actionValue: actionValue,
      id: id,
      tag: tag,
      duration: duration,
      decoration: decoration,
      iconLeft: iconLeft,
      iconRight: iconRight,
    );
  }

  /// Closes a specific snackbar by its handle.
  static Future<bool> closeSnackbar(SnackbarHandle handle) {
    return ContextlessSnackbars.instance.close(handle);
  }

  /// Closes a snackbar by its ID.
  static Future<bool> closeSnackbarById(String id) {
    return ContextlessSnackbars.closeById(id);
  }

  /// Closes all snackbars with a specific tag.
  static Future<int> closeSnackbarsByTag(String tag) {
    return ContextlessSnackbars.closeByTag(tag);
  }

  /// Closes all currently active snackbars.
  static Future<int> closeAllSnackbars() {
    return ContextlessSnackbars.closeAll();
  }

  // ============================================================================
  // Toast Methods
  // ============================================================================

  /// Shows a toast without requiring a BuildContext.
  static ToastHandle showToast(
    Widget content, {
    String? id,
    String? tag,
    Duration duration = const Duration(seconds: 2),
    Alignment alignment = Alignment.bottomCenter,
    ToastDecoration? decoration,
    Widget? iconLeft,
    Widget? iconRight,
  }) {
    return ContextlessToasts.show(
      content,
      id: id,
      tag: tag,
      duration: duration,
      alignment: alignment,
      decoration: decoration,
      iconLeft: iconLeft,
      iconRight: iconRight,
    );
  }

  /// Closes a specific toast by its handle.
  static Future<bool> closeToast(ToastHandle handle) {
    return ContextlessToasts.close(handle);
  }

  /// Closes a toast by its ID.
  static Future<bool> closeToastById(String id) {
    return ContextlessToasts.closeById(id);
  }

  /// Closes all toasts with a specific tag.
  static Future<int> closeToastsByTag(String tag) {
    return ContextlessToasts.closeByTag(tag);
  }

  /// Closes all currently active toasts.
  static Future<int> closeAllToasts() {
    return ContextlessToasts.closeAll();
  }

  // ============================================================================
  // Bottom Sheet Methods
  // ============================================================================

  /// Shows a bottom sheet without requiring a BuildContext.
  static BottomSheetHandle showBottomSheet(
    Widget content, {
    String? id,
    String? tag,
    bool isDismissible = true,
    bool enableDrag = true,
    BottomSheetDecoration? decoration,
  }) {
    return ContextlessBottomSheets.show(
      content,
      id: id,
      tag: tag,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      decoration: decoration,
    );
  }

  /// Shows an async bottom sheet that returns a result when closed.
  static BottomSheetHandle showBottomSheetAsync<T>(
    Widget content, {
    String? id,
    String? tag,
    bool isDismissible = true,
    bool enableDrag = true,
    BottomSheetDecoration? decoration,
  }) {
    return ContextlessBottomSheets.showAsync<T>(
      content,
      id: id,
      tag: tag,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      decoration: decoration,
    );
  }

  /// Closes a specific bottom sheet by its handle.
  static Future<bool> closeBottomSheet(BottomSheetHandle handle) {
    return ContextlessBottomSheets.close(handle);
  }

  /// Closes a bottom sheet by its ID.
  static Future<bool> closeBottomSheetById(String id) {
    return ContextlessBottomSheets.closeById(id);
  }

  /// Closes all bottom sheets with a specific tag.
  static Future<int> closeBottomSheetsByTag(String tag) {
    return ContextlessBottomSheets.closeByTag(tag);
  }

  /// Closes all currently active bottom sheets.
  static Future<int> closeAllBottomSheets() {
    return ContextlessBottomSheets.closeAll();
  }

  // ============================================================================
  // Global Methods
  // ============================================================================

  /// Closes all active UI components (dialogs, snackbars, toasts, bottom sheets).
  static Future<void> closeAll() async {
    await Future.wait([
      closeAllDialogs(),
      closeAllSnackbars(),
      closeAllToasts(),
      closeAllBottomSheets(),
    ]);
  }

  /// Disposes all UI subsystems.
  static void dispose() {
    ContextlessDialogs.instance.dispose();
    ContextlessSnackbars.dispose();
    ContextlessToasts.dispose();
    ContextlessBottomSheets.dispose();
  }
}

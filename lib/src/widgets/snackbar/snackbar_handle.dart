import 'dart:async';
import '../../core/base/base_handle.dart';

/// A handle that represents an active snackbar.
///
/// This handle can be used to close a specific snackbar or check if it's still active.
class SnackbarHandle extends BaseHandle {
  /// Static callback function for closing snackbars.
  /// This is set by the ContextlessSnackbars system during initialization.
  static Future<bool> Function(SnackbarHandle)? _closeCallback;

  /// Creates a new snackbar handle.
  SnackbarHandle({
    super.id,
    super.tag,
    super.openedAt,
  });

  /// Creates a snackbar handle for async operations.
  SnackbarHandle._withCompleter({
    String? id,
    String? tag,
    DateTime? openedAt,
    required Completer<dynamic> completer,
  }) : super.withCompleter(
          id: id,
          tag: tag,
          openedAt: openedAt,
          completer: completer,
        );

  /// Creates a snackbar handle for async operations.
  static SnackbarHandle async({
    String? id,
    String? tag,
    DateTime? openedAt,
  }) {
    final completer = Completer<dynamic>();
    return SnackbarHandle._withCompleter(
      id: id,
      tag: tag,
      openedAt: openedAt,
      completer: completer,
    );
  }

  /// Sets the close callback function. This is called internally by the system.
  static void setCloseCallback(Future<bool> Function(SnackbarHandle) callback) {
    _closeCallback = callback;
  }

  @override
  Future<bool> close() async {
    if (_closeCallback == null) {
      throw StateError(
        'SnackbarHandle close callback not set. '
        'Make sure ContextlessSnackbars.init() has been called.'
      );
    }
    return await _closeCallback!(this);
  }
}

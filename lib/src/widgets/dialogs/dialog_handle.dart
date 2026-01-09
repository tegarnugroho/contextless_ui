import 'dart:async';
import '../../core/base/base_handle.dart';

/// A handle that represents an open dialog.
///
/// This handle can be used to close a specific dialog or check if it's still open.
class DialogHandle extends BaseHandle {
  /// Static callback function for closing dialogs.
  /// This is set by the ContextlessDialogs system during initialization.
  static Future<bool> Function(DialogHandle)? _closeCallback;

  /// Creates a new dialog handle.
  DialogHandle({
    super.id,
    super.tag,
    super.openedAt,
  });

  /// Creates a dialog handle for async operations.
  DialogHandle._withCompleter({
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

  /// Creates a dialog handle for async operations.
  static DialogHandle async({
    String? id,
    String? tag,
    DateTime? openedAt,
  }) {
    final completer = Completer<dynamic>();
    return DialogHandle._withCompleter(
      id: id,
      tag: tag,
      openedAt: openedAt,
      completer: completer,
    );
  }

  /// Sets the close callback function. This is called internally by the system.
  static void setCloseCallback(Future<bool> Function(DialogHandle) callback) {
    _closeCallback = callback;
  }

  @override
  Future<bool> close() async {
    if (_closeCallback == null) {
      throw StateError('DialogHandle close callback not set. '
          'Make sure ContextlessDialogs.init() has been called.');
    }
    return await _closeCallback!(this);
  }
}

import 'dart:async';
import '../../core/base/base_handle.dart';

/// A handle that represents an active toast.
///
/// This handle can be used to close a specific toast or check if it's still active.
class ToastHandle extends BaseHandle {
  /// Static callback function for closing toasts.
  /// This is set by the ContextlessToasts system during initialization.
  static Future<bool> Function(ToastHandle)? _closeCallback;

  /// Creates a new toast handle.
  ToastHandle({
    super.id,
    super.tag,
    super.openedAt,
  });

  /// Creates a toast handle for async operations.
  ToastHandle._withCompleter({
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

  /// Creates a toast handle for async operations.
  static ToastHandle async({
    String? id,
    String? tag,
    DateTime? openedAt,
  }) {
    final completer = Completer<dynamic>();
    return ToastHandle._withCompleter(
      id: id,
      tag: tag,
      openedAt: openedAt,
      completer: completer,
    );
  }

  /// Sets the close callback function. This is called internally by the system.
  static void setCloseCallback(Future<bool> Function(ToastHandle) callback) {
    _closeCallback = callback;
  }

  @override
  Future<bool> close() async {
    if (_closeCallback == null) {
      throw StateError('ToastHandle close callback not set. '
          'Make sure ContextlessToasts.init() has been called.');
    }
    return await _closeCallback!(this);
  }
}

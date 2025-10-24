import 'dart:async';
import '../../core/base/base_handle.dart';

/// A handle that represents an active toast.
///
/// This handle can be used to close a specific toast or check if it's still active.
class ToastHandle extends BaseHandle {
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

  @override
  Future<bool> close() async {
    // This will be implemented by the main ContextlessUi class
    // to avoid circular dependency issues
    throw UnimplementedError(
        'Toast closing should be handled through ContextlessToasts.close(handle) '
        'or ContextlessUi.toasts.close(handle)');
  }
}

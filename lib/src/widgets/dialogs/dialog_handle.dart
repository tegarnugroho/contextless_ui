import 'dart:async';
import '../../core/base/base_handle.dart';

/// A handle that represents an open dialog.
///
/// This handle can be used to close a specific dialog or check if it's still open.
class DialogHandle extends BaseHandle {
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

  @override
  Future<bool> close() async {
    // This will be implemented by the main ContextlessDialogs class
    // to avoid circular dependency issues
    throw UnimplementedError(
        'Dialog closing should be handled through ContextlessDialogs.close(handle)');
  }
}

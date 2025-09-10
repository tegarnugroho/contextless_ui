import 'dart:async';
import '../core/base/base_handle.dart';

/// A handle that represents an active snackbar.
///
/// This handle can be used to close a specific snackbar or check if it's still active.
class SnackbarHandle extends BaseHandle {
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

  @override
  Future<bool> close() async {
    // This will be implemented by the main ContextlessUi class
    // to avoid circular dependency issues
    throw UnimplementedError(
      'Snackbar closing should be handled through ContextlessSnackbars.close(handle) '
      'or ContextlessUi.snackbars.close(handle)'
    );
  }
}

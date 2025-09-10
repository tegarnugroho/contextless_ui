import 'dart:async';
import '../core/base/base_handle.dart';

/// A handle that represents an active bottom sheet.
///
/// This handle can be used to close a specific bottom sheet or check if it's still active.
class BottomSheetHandle extends BaseHandle {
  /// Creates a new bottom sheet handle.
  BottomSheetHandle({
    super.id,
    super.tag,
    super.openedAt,
  });

  /// Creates a bottom sheet handle for async operations.
  BottomSheetHandle._withCompleter({
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

  /// Creates a bottom sheet handle for async operations.
  static BottomSheetHandle async({
    String? id,
    String? tag,
    DateTime? openedAt,
  }) {
    final completer = Completer<dynamic>();
    return BottomSheetHandle._withCompleter(
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
      'BottomSheet closing should be handled through ContextlessBottomSheets.close(handle) '
      'or ContextlessUi.bottomSheets.close(handle)'
    );
  }
}

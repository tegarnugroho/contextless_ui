import 'dart:async';
import '../../core/base/base_handle.dart';

/// A handle that represents an active bottom sheet.
///
/// This handle can be used to close a specific bottom sheet or check if it's still active.
class BottomSheetHandle extends BaseHandle {
  /// Static callback function for closing bottom sheets.
  /// This is set by the ContextlessBottomSheets system during initialization.
  static Future<bool> Function(BottomSheetHandle)? _closeCallback;

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

  /// Sets the close callback function. This is called internally by the system.
  static void setCloseCallback(
      Future<bool> Function(BottomSheetHandle) callback) {
    _closeCallback = callback;
  }

  @override
  Future<bool> close() async {
    if (_closeCallback == null) {
      throw StateError('BottomSheetHandle close callback not set. '
          'Make sure ContextlessBottomSheets.init() has been called.');
    }
    return await _closeCallback!(this);
  }
}

import 'dart:async';
import '../common/id.dart';

/// Base typedef for component IDs.
typedef ComponentId = String;

/// Base abstract class for all UI component handles.
///
/// This provides common functionality for all UI components like dialogs,
/// snackbars, toasts, and bottom sheets.
abstract class BaseHandle {
  /// Unique identifier for this component.
  final ComponentId id;

  /// Optional tag for grouping components.
  final String? tag;

  /// When this component was opened.
  final DateTime openedAt;

  /// Completer for async components that return a result.
  Completer<dynamic>? _completer;

  /// Gets the completer (for internal use).
  Completer<dynamic>? get completer => _completer;

  /// Creates a new component handle.
  BaseHandle({
    String? id,
    this.tag,
    DateTime? openedAt,
  })  : id = id ?? IdUtils.generateUuid(),
        openedAt = openedAt ?? DateTime.now();

  /// Creates a component handle for async operations with completer.
  BaseHandle.withCompleter({
    String? id,
    this.tag,
    DateTime? openedAt,
    required Completer<dynamic> completer,
  })  : id = id ?? IdUtils.generateUuid(),
        openedAt = openedAt ?? DateTime.now(),
        _completer = completer;

  /// Closes this component.
  ///
  /// Returns true if the component was successfully closed, false otherwise.
  /// This calls the respective component's close method internally.
  Future<bool> close();

  /// Waits for this component to be closed and returns its result.
  ///
  /// This is only useful for async components. For regular components,
  /// this will complete when the component is closed with null result.
  Future<T?> result<T>() async {
    if (_completer == null) {
      return null;
    }
    return await _completer!.future as T?;
  }

  /// Completes this async component with a result.
  ///
  /// This is typically called internally when the component is dismissed
  /// with a specific result.
  void complete([dynamic result]) {
    if (_completer != null && !_completer!.isCompleted) {
      _completer!.complete(result);
    }
  }

  /// Completes this async component with an error.
  void completeError(Object error, [StackTrace? stackTrace]) {
    if (_completer != null && !_completer!.isCompleted) {
      _completer!.completeError(error, stackTrace);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BaseHandle && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return '${runtimeType}(id: $id, tag: $tag, openedAt: $openedAt)';
  }
}

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../common/utils/id.dart';

/// Type alias for UI component ID
typedef UiId = String;

/// Types of UI components
enum UiType {
  /// Snackbar notification
  snackbar,
  /// Bottom sheet
  bottomSheet,
  /// Toast notification
  toast,
  /// Modal dialog (inherited from contextless_dialogs)
  dialog,
}

/// Types of UI events
enum UiEventType {
  /// UI component was shown
  opened,
  /// UI component was closed/dismissed
  closed,
}

/// Handle for a UI component that allows interaction without BuildContext
class UiHandle {
  /// Unique identifier for this UI component
  final String id;
  
  /// Optional tag for grouping UI components
  final String? tag;
  
  /// Type of UI component
  final UiType type;
  
  /// When this UI component was opened
  final DateTime openedAt;
  
  /// Optional completer for async UI components
  Completer<dynamic>? _completer;
  
  /// Creates a new UI handle
  UiHandle({
    String? id,
    this.tag,
    required this.type,
  }) : id = id ?? generateId(),
        openedAt = DateTime.now();
  
  /// Creates a new async UI handle that can return a result
  UiHandle.async({
    String? id,
    this.tag,
    required this.type,
  }) : id = id ?? generateId(),
        openedAt = DateTime.now(),
        _completer = Completer<dynamic>();
  
  /// Future that completes when this UI component is closed (async handles only)
  Future<T?> future<T>() {
    if (_completer == null) {
      throw StateError('This handle is not async. Use UiHandle.async() constructor.');
    }
    return _completer!.future.then((value) => value as T?);
  }
  
  /// Whether this handle has an async completer
  bool get isAsync => _completer != null;
  
  /// Whether this handle is completed (async handles only)
  bool get isCompleted => _completer?.isCompleted ?? false;
  
  /// Completes the handle with a result (async handles only)
  void complete([dynamic result]) {
    if (_completer == null) return;
    if (!_completer!.isCompleted) {
      _completer!.complete(result);
    }
  }
  
  /// Completes the handle with an error (async handles only)
  void completeError(Object error, [StackTrace? stackTrace]) {
    if (_completer == null) return;
    if (!_completer!.isCompleted) {
      _completer!.completeError(error, stackTrace);
    }
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UiHandle && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() => 'UiHandle(id: $id, type: $type, tag: $tag)';
}

/// Event emitted when UI components are opened or closed
@immutable
class UiEvent {
  /// The handle of the UI component that triggered this event
  final UiHandle handle;
  
  /// Type of event (opened/closed)
  final UiEventType type;
  
  /// Result value if the UI component was closed with a result
  final dynamic result;
  
  /// Creates a new UI event
  const UiEvent({
    required this.handle,
    required this.type,
    this.result,
  });
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UiEvent &&
        other.handle == handle &&
        other.type == type &&
        other.result == result;
  }
  
  @override
  int get hashCode => Object.hash(handle, type, result);
  
  @override
  String toString() => 'UiEvent(handle: $handle, type: $type, result: $result)';
}

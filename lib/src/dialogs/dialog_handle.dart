import 'dart:async';

import '../common/utils/id.dart';

/// Typedef for dialog IDs.
typedef DialogId = String;

/// A handle that represents an open dialog.
/// 
/// This handle can be used to close a specific dialog or check if it's still open.
class DialogHandle {
  /// Unique identifier for this dialog.
  final DialogId id;
  
  /// Optional tag for grouping dialogs.
  final String? tag;
  
  /// When this dialog was opened.
  final DateTime openedAt;
  
  /// Completer for async dialogs that return a result.
  Completer<dynamic>? _completer;
  
  /// Gets the completer (for internal use).
  Completer<dynamic>? get completer => _completer;
  
  /// Creates a new dialog handle.
  DialogHandle({
    String? id,
    this.tag,
    DateTime? openedAt,
  }) : 
    id = id ?? IdUtils.generateUuid(),
    openedAt = openedAt ?? DateTime.now();
    
  /// Creates a dialog handle for async operations.
  DialogHandle._withCompleter({
    String? id,
    this.tag,
    DateTime? openedAt,
    required Completer<dynamic> completer,
  }) : 
    id = id ?? IdUtils.generateUuid(),
    openedAt = openedAt ?? DateTime.now(),
    _completer = completer;
    
  /// Creates a dialog handle for async operations.
  static DialogHandle async<T>({
    String? id,
    String? tag,
    DateTime? openedAt,
  }) {
    return DialogHandle._withCompleter(
      id: id,
      tag: tag,
      openedAt: openedAt,
      completer: Completer<T>(),
    );
  }
  
  /// Future that completes when the dialog is closed (for async dialogs).
  Future<dynamic> get future => _completer?.future ?? Future.value(null);
  
  /// Whether this dialog handle supports async operations.
  bool get isAsync => _completer != null;
  
  /// Completes the async dialog with the given result.
  void complete(dynamic result) {
    _completer?.complete(result);
  }
  
  /// Completes the async dialog with an error.
  void completeError(Object error, [StackTrace? stackTrace]) {
    _completer?.completeError(error, stackTrace);
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DialogHandle && other.id == id;
  }
  
  @override
  int get hashCode => id.hashCode;
  
  @override
  String toString() => 'DialogHandle(id: $id, tag: $tag, openedAt: $openedAt)';
}

/// Event types for dialog lifecycle.
enum DialogEventType {
  /// Dialog was opened.
  opened,
  /// Dialog was closed.
  closed,
}

/// An event representing a dialog lifecycle change.
class DialogEvent {
  /// The type of event.
  final DialogEventType type;
  
  /// The handle of the dialog that triggered this event.
  final DialogHandle handle;
  
  /// The result returned when the dialog was closed (if any).
  final dynamic result;
  
  /// When this event occurred.
  final DateTime timestamp;
  
  /// Creates a new dialog event.
  DialogEvent({
    required this.type,
    required this.handle,
    this.result,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
        
  /// Creates an opened event.
  factory DialogEvent.opened(DialogHandle handle) {
    return DialogEvent(
      type: DialogEventType.opened,
      handle: handle,
      timestamp: DateTime.now(),
    );
  }
  
  /// Creates a closed event.
  factory DialogEvent.closed(DialogHandle handle, [dynamic result]) {
    return DialogEvent(
      type: DialogEventType.closed,
      handle: handle,
      result: result,
      timestamp: DateTime.now(),
    );
  }
  
  @override
  String toString() {
    return 'DialogEvent(type: $type, handle: ${handle.id}, result: $result, timestamp: $timestamp)';
  }
}

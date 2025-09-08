import 'dart:async';
import 'package:flutter/material.dart';

import 'dialog_handle.dart';
import 'overlay_manager.dart';

/// Controller that manages dialog lifecycle, tracking, and events.
class DialogController {
  final OverlayManager _overlayManager = OverlayManager();
  final StreamController<DialogEvent> _eventController = 
      StreamController<DialogEvent>.broadcast();
  
  /// Stream of dialog events.
  Stream<DialogEvent> get events => _eventController.stream;
  
  /// Initializes the controller.
  void init({
    GlobalKey<NavigatorState>? navigatorKey,
    GlobalKey<OverlayState>? overlayKey,
  }) {
    _overlayManager.init(
      navigatorKey: navigatorKey,
      overlayKey: overlayKey,
    );
  }
  
  /// Whether the controller is properly initialized.
  bool get isInitialized => _overlayManager.isInitialized;
  
  /// Shows a dialog and returns a handle.
  DialogHandle show(
    Widget dialog, {
    String? id,
    String? tag,
    bool barrierDismissible = true,
    Color? barrierColor,
    Duration? transitionDuration,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    if (!isInitialized) {
      throw StateError('ContextlessDialogs not initialized. Call init() first.');
    }
    
    final handle = DialogHandle(
      id: id,
      tag: tag,
    );
    
    _overlayManager.showDialog(
      handle: handle,
      dialog: dialog,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      transitionsBuilder: transitionsBuilder,
      onBarrierTap: () {
        // Emit closed event when barrier is tapped
        _eventController.add(DialogEvent.closed(handle));
      },
    );
    
    // Emit opened event
    _eventController.add(DialogEvent.opened(handle));
    
    return handle;
  }
  
  /// Shows an async dialog that returns a result.
  Future<T?> showAsync<T>(
    Widget dialog, {
    String? id,
    String? tag,
    bool barrierDismissible = true,
    Color? barrierColor,
    Duration? transitionDuration,
    RouteTransitionsBuilder? transitionsBuilder,
  }) {
    if (!isInitialized) {
      throw StateError('ContextlessDialogs not initialized. Call init() first.');
    }
    
    final handle = DialogHandle.async<T>(
      id: id,
      tag: tag,
    );
    
    _overlayManager.showDialog(
      handle: handle,
      dialog: dialog,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      transitionsBuilder: transitionsBuilder,
      onBarrierTap: () {
        // Complete with null and emit closed event when barrier is tapped
        handle.complete(null);
        _eventController.add(DialogEvent.closed(handle));
      },
    );
    
    // Emit opened event
    _eventController.add(DialogEvent.opened(handle));
    
    return handle.future as Future<T?>;
  }
  
  /// Closes a dialog by handle.
  bool close(DialogHandle handle, [dynamic result]) {
    return closeById(handle.id, result);
  }
  
  /// Closes a dialog by ID.
  bool closeById(String id, [dynamic result]) {
    if (!isInitialized) {
      throw StateError('ContextlessDialogs not initialized. Call init() first.');
    }
    
    // Find the handle before removing
    final handles = _overlayManager.openDialogHandles;
    final handleIndex = handles.indexWhere((h) => h.id == id);
    
    if (handleIndex == -1) {
      return false; // Dialog not found
    }
    
    final handle = handles[handleIndex];
    final success = _overlayManager.removeDialog(id, result);
    
    if (success) {
      _eventController.add(DialogEvent.closed(handle, result));
    }
    
    return success;
  }
  
  /// Closes dialogs by tag.
  int closeByTag(String tag, [dynamic result]) {
    if (!isInitialized) {
      throw StateError('ContextlessDialogs not initialized. Call init() first.');
    }
    
    // Get handles before removing
    final handlesToClose = _overlayManager.openDialogHandles
        .where((handle) => handle.tag == tag)
        .toList();
    
    final count = _overlayManager.removeDialogsByTag(tag, result);
    
    // Emit closed events for all removed dialogs
    for (final handle in handlesToClose) {
      _eventController.add(DialogEvent.closed(handle, result));
    }
    
    return count;
  }
  
  /// Closes all dialogs.
  void closeAll([dynamic result]) {
    if (!isInitialized) {
      throw StateError('ContextlessDialogs not initialized. Call init() first.');
    }
    
    // Get all handles before removing
    final allHandles = _overlayManager.openDialogHandles.toList();
    
    _overlayManager.removeAllDialogs(result);
    
    // Emit closed events for all removed dialogs
    for (final handle in allHandles) {
      _eventController.add(DialogEvent.closed(handle, result));
    }
  }
  
  /// Checks if a dialog is open by handle or ID.
  bool isOpen(Object handleOrId) {
    if (!isInitialized) {
      return false;
    }
    
    String id;
    if (handleOrId is DialogHandle) {
      id = handleOrId.id;
    } else if (handleOrId is String) {
      id = handleOrId;
    } else {
      throw ArgumentError('handleOrId must be either DialogHandle or String');
    }
    
    return _overlayManager.isDialogOpen(id);
  }
  
  /// Gets all currently open dialog handles.
  List<DialogHandle> get openDialogs => _overlayManager.openDialogHandles;
  
  /// Gets the count of currently open dialogs.
  int get openDialogCount => _overlayManager.openDialogIds.length;
  
  /// Disposes the controller and closes all dialogs.
  void dispose() {
    // Close all dialogs first
    final allHandles = _overlayManager.openDialogHandles.toList();
    _overlayManager.removeAllDialogs();
    
    // Emit closed events
    for (final handle in allHandles) {
      _eventController.add(DialogEvent.closed(handle));
    }
    
    // Dispose resources
    _overlayManager.dispose();
    _eventController.close();
  }
}

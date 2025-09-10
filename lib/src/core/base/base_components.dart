import 'package:flutter/material.dart';
import 'base_handle.dart';

/// Base abstract class for all overlay managers.
///
/// This provides common functionality for managing UI components
/// that are displayed using Flutter's Overlay system.
abstract class BaseOverlayManager<T extends BaseHandle> {
  GlobalKey<NavigatorState>? _navigatorKey;
  GlobalKey<OverlayState>? _overlayKey;

  /// Map to track active components.
  final Map<String, dynamic> activeComponents = {};

  /// Initializes the overlay manager with navigator or overlay key.
  void init({
    GlobalKey<NavigatorState>? navigatorKey,
    GlobalKey<OverlayState>? overlayKey,
  }) {
    if (navigatorKey == null && overlayKey == null) {
      throw ArgumentError('Either navigatorKey or overlayKey must be provided');
    }

    _navigatorKey = navigatorKey;
    _overlayKey = overlayKey;
  }

  /// Gets the current overlay state.
  OverlayState? get overlay {
    if (_overlayKey?.currentState != null) {
      return _overlayKey!.currentState!;
    }

    if (_navigatorKey?.currentState?.overlay != null) {
      return _navigatorKey!.currentState!.overlay!;
    }

    return null;
  }

  /// Whether the manager has been initialized.
  bool get isInitialized => overlay != null;

  /// Shows a component and returns its handle.
  T show(
    Widget content, {
    String? id,
    String? tag,
    Map<String, dynamic>? options,
  });

  /// Closes a specific component by its handle.
  Future<bool> close(T handle);

  /// Closes a specific component by its ID.
  Future<bool> closeById(String id);

  /// Closes all components with a specific tag.
  Future<int> closeByTag(String tag);

  /// Closes all active components.
  Future<int> closeAll();

  /// Gets all active component handles.
  List<T> get activeHandles;

  /// Gets a specific component handle by ID.
  T? getById(String id);

  /// Gets all component handles with a specific tag.
  List<T> getByTag(String tag);

  /// Checks if a component with the given ID is currently active.
  bool isActive(String id) => activeComponents.containsKey(id);

  /// Gets the count of active components.
  int get activeCount => activeComponents.length;
}

/// Base abstract class for all controllers.
///
/// This provides common functionality for component controllers
/// that manage the lifecycle and state of UI components.
abstract class BaseController<T extends BaseHandle> {
  BaseOverlayManager<T>? _overlayManager;

  /// Gets the overlay manager instance.
  BaseOverlayManager<T>? get overlayManager => _overlayManager;

  /// Whether the controller has been initialized.
  bool get isInitialized => _overlayManager?.isInitialized ?? false;

  /// Initializes the controller.
  void init({
    GlobalKey<NavigatorState>? navigatorKey,
    GlobalKey<OverlayState>? overlayKey,
  }) {
    _overlayManager = createOverlayManager();
    _overlayManager!.init(
      navigatorKey: navigatorKey,
      overlayKey: overlayKey,
    );
  }

  /// Creates the appropriate overlay manager for this controller.
  BaseOverlayManager<T> createOverlayManager();

  /// Shows a component.
  T show(
    Widget content, {
    String? id,
    String? tag,
    Map<String, dynamic>? options,
  }) {
    if (_overlayManager == null) {
      throw StateError('Controller not initialized. Call init() first.');
    }
    return _overlayManager!.show(
      content,
      id: id,
      tag: tag,
      options: options,
    );
  }

  /// Closes a specific component.
  Future<bool> close(T handle) {
    if (_overlayManager == null) return Future.value(false);
    return _overlayManager!.close(handle);
  }

  /// Closes a component by ID.
  Future<bool> closeById(String id) {
    if (_overlayManager == null) return Future.value(false);
    return _overlayManager!.closeById(id);
  }

  /// Closes components by tag.
  Future<int> closeByTag(String tag) {
    if (_overlayManager == null) return Future.value(0);
    return _overlayManager!.closeByTag(tag);
  }

  /// Closes all components.
  Future<int> closeAll() {
    if (_overlayManager == null) return Future.value(0);
    return _overlayManager!.closeAll();
  }

  /// Gets all active handles.
  List<T> get activeHandles {
    if (_overlayManager == null) return [];
    return _overlayManager!.activeHandles;
  }

  /// Gets a handle by ID.
  T? getById(String id) {
    if (_overlayManager == null) return null;
    return _overlayManager!.getById(id);
  }

  /// Gets handles by tag.
  List<T> getByTag(String tag) {
    if (_overlayManager == null) return [];
    return _overlayManager!.getByTag(tag);
  }
}

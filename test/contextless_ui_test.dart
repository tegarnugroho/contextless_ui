import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:contextless_ui/contextless_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GlobalKey<NavigatorState> navigatorKey;
  late GlobalKey<OverlayState> overlayKey;

  setUp(() {
    navigatorKey = GlobalKey<NavigatorState>();
    overlayKey = GlobalKey<OverlayState>();
  });

  group('Package Import Test', () {
    test('should be able to import all main classes', () {
      // Test that all main classes can be imported and instantiated
      expect(ContextlessSnackbars, isNotNull);
      expect(ContextlessToasts, isNotNull);
      expect(ContextlessBottomSheets, isNotNull);
      expect(ContextlessUi, isNotNull);
    });

    test('should be able to create handles', () {
      // Test that handle classes exist
      final snackbarHandle = SnackbarHandle(id: 'test');
      final toastHandle = ToastHandle(id: 'test');
      final bottomSheetHandle = BottomSheetHandle(id: 'test');

      expect(snackbarHandle.id, 'test');
      expect(toastHandle.id, 'test');
      expect(bottomSheetHandle.id, 'test');
    });
  });

  group('Basic Initialization Tests', () {
    test('ContextlessSnackbars should have init method', () {
      expect(() => ContextlessSnackbars.init(navigatorKey: navigatorKey, overlayKey: overlayKey), returnsNormally);
    });

    test('ContextlessToasts should have init method', () {
      expect(() => ContextlessToasts.init(navigatorKey: navigatorKey, overlayKey: overlayKey), returnsNormally);
    });

    test('ContextlessBottomSheets should have init method', () {
      expect(() => ContextlessBottomSheets.init(navigatorKey: navigatorKey, overlayKey: overlayKey), returnsNormally);
    });

    test('ContextlessUi should have init method', () {
      expect(() => ContextlessUi.init(navigatorKey: navigatorKey, overlayKey: overlayKey), returnsNormally);
    });
  });
}
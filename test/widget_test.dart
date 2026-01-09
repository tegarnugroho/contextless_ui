import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:contextless_ui/contextless_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Basic Functionality Tests', () {
    testWidgets('ContextlessSnackbars should initialize', (WidgetTester tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(body: Container()),
      ));

      ContextlessSnackbars.init(navigatorKey: navigatorKey);
      await tester.pump(); // Allow the widget tree to settle
      expect(ContextlessSnackbars.isInitialized, true);
    });

    testWidgets('ContextlessToasts should initialize', (WidgetTester tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(body: Container()),
      ));

      ContextlessToasts.init(navigatorKey: navigatorKey);
      await tester.pump(); // Allow the widget tree to settle
      expect(ContextlessToasts.isInitialized, true);
    });

    testWidgets('ContextlessBottomSheets should initialize', (WidgetTester tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(body: Container()),
      ));

      ContextlessBottomSheets.init(navigatorKey: navigatorKey);
      await tester.pump(); // Allow the widget tree to settle
      expect(ContextlessBottomSheets.isInitialized, true);
    });

    testWidgets('ContextlessUi should initialize all components', (WidgetTester tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(body: Container()),
      ));

      ContextlessUi.init(navigatorKey: navigatorKey);
      await tester.pump(); // Allow the widget tree to settle
      expect(ContextlessSnackbars.isInitialized, true);
      expect(ContextlessToasts.isInitialized, true);
      expect(ContextlessBottomSheets.isInitialized, true);
    });

    test('should create snackbar handle', () {
      final handle = SnackbarHandle(id: 'test');
      expect(handle.id, 'test');
      expect(handle, isA<SnackbarHandle>());
    });

    test('should create toast handle', () {
      final handle = ToastHandle(id: 'test');
      expect(handle.id, 'test');
      expect(handle, isA<ToastHandle>());
    });

    test('should create bottom sheet handle', () {
      final handle = BottomSheetHandle(id: 'test');
      expect(handle.id, 'test');
      expect(handle, isA<BottomSheetHandle>());
    });

    test('should handle async snackbar result', () async {
      final handle = SnackbarHandle.async(id: 'test');
      handle.complete('result');
      final result = await handle.result<String>();
      expect(result, 'result');
    });
  });
}
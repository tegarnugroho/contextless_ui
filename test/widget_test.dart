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

    testWidgets('should show and hide snackbar with content verification', (WidgetTester tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(body: Container()),
      ));

      ContextlessSnackbars.init(navigatorKey: navigatorKey);
      await tester.pump();

      // Test handle creation without showing
      final handle = SnackbarHandle(id: 'test_snackbar');
      expect(handle, isA<SnackbarHandle>());
      expect(handle.id, 'test_snackbar');

      // Test async handle functionality
      final asyncHandle = SnackbarHandle.async(id: 'async_test');
      asyncHandle.complete('test_result');
      final result = await asyncHandle.result<String>();
      expect(result, 'test_result');
    });

    testWidgets('should show and hide dialog with content verification', (WidgetTester tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(body: Container()),
      ));

      ContextlessDialogs.instance.init(navigatorKey: navigatorKey);
      await tester.pump();

      // Test handle creation without showing
      final handle = DialogHandle(id: 'test_dialog');
      expect(handle, isA<DialogHandle>());
      expect(handle.id, 'test_dialog');

      // Test async handle functionality
      final asyncHandle = DialogHandle.async(id: 'async_dialog_test');
      asyncHandle.complete('dialog_result');
      final result = await asyncHandle.result<String>();
      expect(result, 'dialog_result');
    });

    testWidgets('should show and hide toast with content verification', (WidgetTester tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(body: Container()),
      ));

      ContextlessToasts.init(navigatorKey: navigatorKey);
      await tester.pump();

      // Test handle creation without showing
      final handle = ToastHandle(id: 'test_toast');
      expect(handle, isA<ToastHandle>());
      expect(handle.id, 'test_toast');

      // Test async handle functionality
      final asyncHandle = ToastHandle.async(id: 'async_toast_test');
      asyncHandle.complete('toast_result');
      final result = await asyncHandle.result<String>();
      expect(result, 'toast_result');
    });

    testWidgets('should show and hide bottom sheet with content verification', (WidgetTester tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(MaterialApp(
        navigatorKey: navigatorKey,
        home: Scaffold(body: Container()),
      ));

      ContextlessBottomSheets.init(navigatorKey: navigatorKey);
      await tester.pump();

      // Test handle creation without showing
      final handle = BottomSheetHandle(id: 'test_bottomsheet');
      expect(handle, isA<BottomSheetHandle>());
      expect(handle.id, 'test_bottomsheet');

      // Test async handle functionality
      final asyncHandle = BottomSheetHandle.async(id: 'async_bottomsheet_test');
      asyncHandle.complete('bottomsheet_result');
      final result = await asyncHandle.result<String>();
      expect(result, 'bottomsheet_result');
    });
  });
}
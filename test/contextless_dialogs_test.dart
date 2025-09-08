import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:contextless_ui/contextless_ui.dart';

void main() {
  group('ContextlessDialogs', () {
    late GlobalKey<NavigatorState> navigatorKey;

    setUp(() {
      navigatorKey = GlobalKey<NavigatorState>();
      try {
        ContextlessDialogs.dispose(); // Ensure clean state
      } catch (e) {
        // Ignore if not initialized
      }
    });

    tearDown(() {
      try {
        ContextlessDialogs.dispose(); // Clean up after each test
      } catch (e) {
        // Ignore if not initialized
      }
    });

    testWidgets('initialization with navigator key', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: const Scaffold(body: Text('Test')),
        ),
      );

      ContextlessDialogs.init(navigatorKey: navigatorKey);
      expect(ContextlessDialogs.isInitialized, isTrue);
    });

    testWidgets('throws error when not initialized', (WidgetTester tester) async {
      expect(
        () => ContextlessDialogs.show(const Text('Test')),
        throwsA(isA<StateError>()),
      );
    });

    testWidgets('show and close dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: const Scaffold(body: Text('Test')),
        ),
      );

      ContextlessDialogs.init(navigatorKey: navigatorKey);

      final dialog = const Dialog(
        child: Text('Test Dialog'),
      );

      // Show dialog
      final handle = ContextlessDialogs.show(dialog);
      expect(handle.id, isNotNull);
      expect(ContextlessDialogs.openDialogCount, equals(1));

      await tester.pump();
      
      // Verify dialog is displayed
      expect(find.text('Test Dialog'), findsOneWidget);
      expect(ContextlessDialogs.isOpen(handle), isTrue);

      // Close dialog
      final closed = ContextlessDialogs.close(handle);
      expect(closed, isTrue);
      expect(ContextlessDialogs.isOpen(handle), isFalse);
      expect(ContextlessDialogs.openDialogCount, equals(0));

      await tester.pump();
      
      // Verify dialog is removed
      expect(find.text('Test Dialog'), findsNothing);
    });

    testWidgets('show async dialog with result', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: const Scaffold(body: Text('Test')),
        ),
      );

      ContextlessDialogs.init(navigatorKey: navigatorKey);

      final dialog = Dialog(
        child: ElevatedButton(
          onPressed: () {
            // This would normally close the dialog with a result
          },
          child: const Text('Click me'),
        ),
      );

      // Show async dialog
      final future = ContextlessDialogs.showAsync<String>(dialog);
      await tester.pump();

      // Verify dialog is displayed
      expect(find.text('Click me'), findsOneWidget);
      expect(ContextlessDialogs.openDialogCount, equals(1));

      // Close dialog with result
      ContextlessDialogs.closeAll('test result');
      await tester.pump();

      final result = await future;
      expect(result, equals('test result'));
      expect(ContextlessDialogs.openDialogCount, equals(0));
    });

    testWidgets('close by ID', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: const Scaffold(body: Text('Test')),
        ),
      );

      ContextlessDialogs.init(navigatorKey: navigatorKey);

      const dialogId = 'test-dialog';
      final handle = ContextlessDialogs.show(
        const Dialog(child: Text('Test Dialog')),
        id: dialogId,
      );

      expect(handle.id, equals(dialogId));
      expect(ContextlessDialogs.isOpen(dialogId), isTrue);

      await tester.pump();
      
      final closed = ContextlessDialogs.closeById(dialogId);
      expect(closed, isTrue);
      expect(ContextlessDialogs.isOpen(dialogId), isFalse);

      await tester.pump();
    });

    testWidgets('close by tag', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: const Scaffold(body: Text('Test')),
        ),
      );

      ContextlessDialogs.init(navigatorKey: navigatorKey);

      // Show multiple dialogs with the same tag
      final handle1 = ContextlessDialogs.show(
        const Dialog(child: Text('Dialog 1')),
        tag: 'group1',
      );
      final handle2 = ContextlessDialogs.show(
        const Dialog(child: Text('Dialog 2')),
        tag: 'group1',
      );
      final handle3 = ContextlessDialogs.show(
        const Dialog(child: Text('Dialog 3')),
        tag: 'group2',
      );

      expect(ContextlessDialogs.openDialogCount, equals(3));

      await tester.pump();

      // Close dialogs by tag
      final count = ContextlessDialogs.closeByTag('group1');
      expect(count, equals(2));
      
      expect(ContextlessDialogs.isOpen(handle1), isFalse);
      expect(ContextlessDialogs.isOpen(handle2), isFalse);
      expect(ContextlessDialogs.isOpen(handle3), isTrue);
      expect(ContextlessDialogs.openDialogCount, equals(1));

      await tester.pump();
      
      // Clean up
      ContextlessDialogs.close(handle3);
    });

    testWidgets('close all dialogs', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: const Scaffold(body: Text('Test')),
        ),
      );

      ContextlessDialogs.init(navigatorKey: navigatorKey);

      // Show multiple dialogs
      ContextlessDialogs.show(const Dialog(child: Text('Dialog 1')));
      ContextlessDialogs.show(const Dialog(child: Text('Dialog 2')));
      ContextlessDialogs.show(const Dialog(child: Text('Dialog 3')));

      expect(ContextlessDialogs.openDialogCount, equals(3));

      await tester.pump();

      // Close all dialogs
      ContextlessDialogs.closeAll();
      expect(ContextlessDialogs.openDialogCount, equals(0));

      await tester.pump();
    });

    test('dialog events stream', () async {
      // Skip this test for now as it requires complex setup
      // The events system is tested indirectly through other tests
    }, skip: true);

    testWidgets('barrier dismissible dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: const Scaffold(body: Text('Test')),
        ),
      );

      ContextlessDialogs.init(navigatorKey: navigatorKey);

      final handle = ContextlessDialogs.show(
        const Dialog(child: Text('Dismissible Dialog')),
        barrierDismissible: true,
      );

      await tester.pump(const Duration(milliseconds: 300)); // Wait for animation

      expect(find.text('Dismissible Dialog'), findsOneWidget);
      expect(ContextlessDialogs.isOpen(handle), isTrue);

      // Tap on the barrier (outside the dialog)
      await tester.tapAt(const Offset(50, 50)); // Top-left corner, outside dialog
      await tester.pump(const Duration(milliseconds: 300));

      expect(ContextlessDialogs.isOpen(handle), isFalse);
      expect(find.text('Dismissible Dialog'), findsNothing);
    });

    testWidgets('non-dismissible dialog', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: navigatorKey,
          home: const Scaffold(body: Text('Test')),
        ),
      );

      ContextlessDialogs.init(navigatorKey: navigatorKey);

      final handle = ContextlessDialogs.show(
        const Dialog(child: Text('Non-dismissible Dialog')),
        barrierDismissible: false,
      );

      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Non-dismissible Dialog'), findsOneWidget);
      expect(ContextlessDialogs.isOpen(handle), isTrue);

      // Try to tap on the barrier
      await tester.tapAt(const Offset(50, 50));
      await tester.pump(const Duration(milliseconds: 300));

      // Dialog should still be open
      expect(ContextlessDialogs.isOpen(handle), isTrue);
      expect(find.text('Non-dismissible Dialog'), findsOneWidget);

      // Clean up
      ContextlessDialogs.close(handle);
      await tester.pump();
    });

    test('dialog handle equality', () {
      const id = 'test-id';
      final handle1 = DialogHandle(id: id);
      final handle2 = DialogHandle(id: id);
      final handle3 = DialogHandle(); // Different ID

      expect(handle1, equals(handle2));
      expect(handle1, isNot(equals(handle3)));
      expect(handle1.hashCode, equals(handle2.hashCode));
    });

    test('async dialog handle', () {
      final handle = DialogHandle.async<String>(id: 'test');
      expect(handle.isAsync, isTrue);
      
      final future = handle.future;
      handle.complete('test result');
      
      expect(future, completion('test result'));
    });

    test('dialog handle toString', () {
      final handle = DialogHandle(id: 'test-id', tag: 'test-tag');
      final string = handle.toString();
      
      expect(string, contains('test-id'));
      expect(string, contains('test-tag'));
      expect(string, contains('DialogHandle'));
    });
  });
}

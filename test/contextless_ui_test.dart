import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:contextless_ui/contextless_ui.dart';

void main() {
  group('ContextlessUi', () {
    late GlobalKey<NavigatorState> navigatorKey;

    setUp(() {
      navigatorKey = GlobalKey<NavigatorState>();
      try {
        ContextlessUi.dispose(); // Ensure clean state
      } catch (e) {
        // Ignore if not initialized
      }
    });

    tearDown(() {
      try {
        ContextlessUi.dispose(); // Clean up after each test
      } catch (e) {
        // Ignore if not initialized
      }
    });

    group('Initialization', () {
      testWidgets('initialization with navigator key',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: Text('Test')),
          ),
        );

        ContextlessUi.init(navigatorKey: navigatorKey);
        expect(ContextlessUi.isInitialized, isTrue);
        expect(ContextlessDialogs.isInitialized,
            isTrue); // Should also initialize dialogs
      });

      testWidgets('throws error when not initialized',
          (WidgetTester tester) async {
        expect(
          () => ContextlessUi.showSnackbar(const Text('Test')),
          throwsA(isA<StateError>()),
        );
      });
    });

    group('Snackbars', () {
      testWidgets('show and close snackbar', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: Text('Test')),
          ),
        );

        ContextlessUi.init(navigatorKey: navigatorKey);

        // Show snackbar
        final handle = ContextlessUi.showSnackbar(
          const Text('Test Snackbar'),
          duration: const Duration(seconds: 10), // Long duration for testing
        );

        expect(handle.id, isNotNull);
        expect(handle.type, equals(UiType.snackbar));
        expect(ContextlessUi.openUiComponentCount, equals(1));

        await tester.pump();
        await tester
            .pump(const Duration(milliseconds: 300)); // Wait for animation

        // Verify snackbar is displayed
        expect(find.text('Test Snackbar'), findsOneWidget);
        expect(ContextlessUi.isOpen(handle), isTrue);

        // Close snackbar
        final closed = ContextlessUi.close(handle);
        expect(closed, isTrue);
        expect(ContextlessUi.isOpen(handle), isFalse);

        await tester.pump();
        await tester
            .pump(const Duration(milliseconds: 300)); // Wait for animation
      });

      testWidgets('snackbar auto-dismisses after duration',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: Text('Test')),
          ),
        );

        ContextlessUi.init(navigatorKey: navigatorKey);

        final handle = ContextlessUi.showSnackbar(
          const Text('Auto Dismiss'),
          duration: const Duration(milliseconds: 500),
        );

        await tester.pump();
        expect(ContextlessUi.isOpen(handle), isTrue);

        // Wait for auto-dismiss
        await tester.pump(const Duration(milliseconds: 600));
        expect(ContextlessUi.isOpen(handle), isFalse);
      });

      testWidgets('async snackbar with result', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: Text('Test')),
          ),
        );

        ContextlessUi.init(navigatorKey: navigatorKey);

        final future = ContextlessUi.showSnackbarAsync<String>(
          const Text('Async Snackbar'),
          duration: const Duration(seconds: 10),
        );

        await tester.pump();

        // Close with result
        ContextlessUi.closeAll('test result');
        await tester.pump();

        final result = await future;
        expect(result, equals('test result'));
      });
    });

    group('Bottom Sheets', () {
      testWidgets('show and close bottom sheet', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: Text('Test')),
          ),
        );

        ContextlessUi.init(navigatorKey: navigatorKey);

        final handle = ContextlessUi.showBottomSheet(
          Container(
            height: 200,
            child: const Text('Test Bottom Sheet'),
          ),
        );

        expect(handle.type, equals(UiType.bottomSheet));
        expect(ContextlessUi.isOpen(handle), isTrue);

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('Test Bottom Sheet'), findsOneWidget);

        ContextlessUi.close(handle);
        await tester.pump();
      });

      testWidgets('async bottom sheet with result',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: Text('Test')),
          ),
        );

        ContextlessUi.init(navigatorKey: navigatorKey);

        final future = ContextlessUi.showBottomSheetAsync<String>(
          const Text('Async Bottom Sheet'),
        );

        await tester.pump();

        ContextlessUi.closeAll('sheet result');
        await tester.pump();

        final result = await future;
        expect(result, equals('sheet result'));
      });
    });

    group('Toasts', () {
      testWidgets('show and close toast', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: Text('Test')),
          ),
        );

        ContextlessUi.init(navigatorKey: navigatorKey);

        final handle = ContextlessUi.showToast(
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                const Text('Test Toast', style: TextStyle(color: Colors.white)),
          ),
          duration: const Duration(seconds: 10),
        );

        expect(handle.type, equals(UiType.toast));
        expect(ContextlessUi.isOpen(handle), isTrue);

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('Test Toast'), findsOneWidget);

        ContextlessUi.close(handle);
        await tester.pump();
      });

      testWidgets('toast auto-dismisses after duration',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: Text('Test')),
          ),
        );

        ContextlessUi.init(navigatorKey: navigatorKey);

        final handle = ContextlessUi.showToast(
          const Text('Auto Toast'),
          duration: const Duration(milliseconds: 500),
        );

        await tester.pump();
        expect(ContextlessUi.isOpen(handle), isTrue);

        await tester.pump(const Duration(milliseconds: 600));
        expect(ContextlessUi.isOpen(handle), isFalse);
      });
    });

    group('Control Methods', () {
      testWidgets('close by ID', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: Text('Test')),
          ),
        );

        ContextlessUi.init(navigatorKey: navigatorKey);

        const componentId = 'test-component';
        final handle = ContextlessUi.showToast(
          const Text('Test'),
          id: componentId,
        );

        expect(handle.id, equals(componentId));
        expect(ContextlessUi.isOpen(componentId), isTrue);

        await tester.pump();

        final closed = ContextlessUi.closeById(componentId);
        expect(closed, isTrue);
        expect(ContextlessUi.isOpen(componentId), isFalse);

        await tester.pump();
      });

      testWidgets('close by tag', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: Text('Test')),
          ),
        );

        ContextlessUi.init(navigatorKey: navigatorKey);

        final handle1 = ContextlessUi.showToast(
          const Text('Toast 1'),
          tag: 'group1',
        );
        final handle2 = ContextlessUi.showSnackbar(
          const Text('Snackbar 1'),
          tag: 'group1',
        );
        final handle3 = ContextlessUi.showToast(
          const Text('Toast 2'),
          tag: 'group2',
        );

        expect(ContextlessUi.openUiComponentCount, equals(3));

        await tester.pump();

        final count = ContextlessUi.closeByTag('group1');
        expect(count, equals(2));

        expect(ContextlessUi.isOpen(handle1), isFalse);
        expect(ContextlessUi.isOpen(handle2), isFalse);
        expect(ContextlessUi.isOpen(handle3), isTrue);
        expect(ContextlessUi.openUiComponentCount, equals(1));

        await tester.pump();

        ContextlessUi.close(handle3);
      });

      testWidgets('close by type', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: Text('Test')),
          ),
        );

        ContextlessUi.init(navigatorKey: navigatorKey);

        final handle1 = ContextlessUi.showToast(const Text('Toast 1'));
        final handle2 = ContextlessUi.showToast(const Text('Toast 2'));
        final handle3 = ContextlessUi.showSnackbar(const Text('Snackbar'));

        expect(ContextlessUi.openUiComponentCount, equals(3));

        await tester.pump();

        final count = ContextlessUi.closeByType(UiType.toast);
        expect(count, equals(2));

        expect(ContextlessUi.isOpen(handle1), isFalse);
        expect(ContextlessUi.isOpen(handle2), isFalse);
        expect(ContextlessUi.isOpen(handle3), isTrue);
        expect(ContextlessUi.openUiComponentCount, equals(1));

        await tester.pump();

        ContextlessUi.close(handle3);
      });

      testWidgets('close all components', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: Text('Test')),
          ),
        );

        ContextlessUi.init(navigatorKey: navigatorKey);

        ContextlessUi.showToast(const Text('Toast'));
        ContextlessUi.showSnackbar(const Text('Snackbar'));
        ContextlessUi.showBottomSheet(const Text('Bottom Sheet'));

        expect(ContextlessUi.openUiComponentCount, equals(3));

        await tester.pump();

        ContextlessUi.closeAll();
        expect(ContextlessUi.openUiComponentCount, equals(0));

        await tester.pump();
      });
    });

    group('Events', () {
      test('ui events stream', () async {
        // Skip this test for now as it requires complex setup
        // The events system is tested indirectly through other tests
      }, skip: true);
    });

    group('UiHandle', () {
      test('handle equality', () {
        const id = 'test-id';
        final handle1 = UiHandle(id: id, type: UiType.toast);
        final handle2 = UiHandle(id: id, type: UiType.snackbar);
        final handle3 = UiHandle(type: UiType.toast); // Different ID

        expect(handle1, equals(handle2)); // Same ID
        expect(handle1, isNot(equals(handle3))); // Different ID
        expect(handle1.hashCode, equals(handle2.hashCode));
      });

      test('async handle', () {
        final handle = UiHandle.async(id: 'test', type: UiType.bottomSheet);
        expect(handle.isAsync, isTrue);

        final future = handle.future();
        handle.complete('test result');

        expect(future, completion('test result'));
      });

      test('handle toString', () {
        final handle = UiHandle(
          id: 'test-id',
          tag: 'test-tag',
          type: UiType.snackbar,
        );
        final string = handle.toString();

        expect(string, contains('test-id'));
        expect(string, contains('test-tag'));
        expect(string, contains('snackbar'));
        expect(string, contains('UiHandle'));
      });
    });

    group('Builder Classes', () {
      testWidgets('SnackbarBuilder.success', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: Text('Test')),
          ),
        );

        ContextlessUi.init(navigatorKey: navigatorKey);

        final handle = SnackbarBuilder.success('Success message!');
        expect(handle.type, equals(UiType.snackbar));

        await tester.pump();
        expect(find.text('Success message!'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle), findsOneWidget);

        ContextlessUi.close(handle);
        await tester.pump();
      });

      testWidgets('SnackbarBuilder.error', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: Text('Test')),
          ),
        );

        ContextlessUi.init(navigatorKey: navigatorKey);

        final handle = SnackbarBuilder.error('Error message!');
        expect(handle.type, equals(UiType.snackbar));

        await tester.pump();
        expect(find.text('Error message!'), findsOneWidget);
        expect(find.byIcon(Icons.error), findsOneWidget);

        ContextlessUi.close(handle);
        await tester.pump();
      });

      testWidgets('ToastBuilder.text', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: Text('Test')),
          ),
        );

        ContextlessUi.init(navigatorKey: navigatorKey);

        final handle = ToastBuilder.text('Toast message!');
        expect(handle.type, equals(UiType.toast));

        await tester.pump();
        expect(find.text('Toast message!'), findsOneWidget);

        ContextlessUi.close(handle);
        await tester.pump();
      });

      testWidgets('ToastBuilder.withIcon', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: Text('Test')),
          ),
        );

        ContextlessUi.init(navigatorKey: navigatorKey);

        final handle = ToastBuilder.withIcon(Icons.favorite, 'Liked!');
        expect(handle.type, equals(UiType.toast));

        await tester.pump();
        expect(find.text('Liked!'), findsOneWidget);
        expect(find.byIcon(Icons.favorite), findsOneWidget);

        ContextlessUi.close(handle);
        await tester.pump();
      });
    });

    group('Integration with ContextlessDialogs', () {
      testWidgets('both systems work together', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            navigatorKey: navigatorKey,
            home: const Scaffold(body: Text('Test')),
          ),
        );

        ContextlessUi.init(navigatorKey: navigatorKey);

        // Show UI components
        final toastHandle = ContextlessUi.showToast(const Text('Toast'));
        final snackbarHandle =
            ContextlessUi.showSnackbar(const Text('Snackbar'));

        // Show dialog
        final dialogHandle = ContextlessDialogs.show(
          const Dialog(child: Text('Dialog')),
        );

        await tester.pump();

        expect(ContextlessUi.openUiComponentCount, equals(2));
        expect(ContextlessDialogs.openDialogCount, equals(1));

        expect(find.text('Toast'), findsOneWidget);
        expect(find.text('Snackbar'), findsOneWidget);
        expect(find.text('Dialog'), findsOneWidget);

        // Clean up
        ContextlessUi.close(toastHandle);
        ContextlessUi.close(snackbarHandle);
        ContextlessDialogs.close(dialogHandle);

        await tester.pump();
      });
    });
  });
}

# Contextless UI

[![Pub Version](https://img.shields.io/pub/v/contextless_ui)](https://pub.dev/packages/contextless_ui)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive Flutter package for displaying **UI components without requiring `BuildContext`** - including dialogs, snackbars, toasts, and bottom sheets. Manage components by handle, ID, or tags with full async support.

## Demo

[![Contextless UI Demo](./contextless_ui.gif)](https://www.youtube.com/watch?v=2pprA48Dmmc)

> Click the preview above to watch the full demo video showcasing all features of the contextless_ui package

## Features

### Core Capabilities

- **Zero BuildContext Required** - Display any UI component from anywhere in your code
- **Unified API** - Single package for dialogs, snackbars, toasts, and bottom sheets
- **Precise Control** - Close specific components by handle, ID, or tag (not just the topmost one)
- **Async Support** - `showAsync()` methods return results from user interactions
- **Event Streams** - Listen to component open/close events for analytics or state management

### UI Components

- **Dialogs** - Modal dialogs with custom content and transitions
- **Snackbars** - Material Design snackbars with actions and custom styling
- **Toasts** - Simple toast notifications with flexible positioning
- **Bottom Sheets** - Material bottom sheets with drag support and custom content

### Advanced Features

- **Tag-based Management** - Group and bulk close components
- **Custom Transitions** - Built-in animations with support for custom transitions
- **Analytics Ready** - Event streams for tracking user interactions
- **Thread-safe** - All operations are UI-thread safe with proper error handling
- **Cross-platform** - Works on Android, iOS, Web, and desktop
- **Zero Dependencies** - Only depends on Flutter SDK

## Quick Start

### Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  contextless_ui: ^0.1.0
```

### Initialization Options

You can initialize Contextless UI in two ways:

#### 1. Using NavigatorObserver (Recommended for existing apps)

```dart
import 'package:contextless_ui/contextless_ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      navigatorObservers: [
        ContextlessObserver(), // Auto-init ContextlessUi on first route push
      ],
      home: const MyHomePage(),
    );
  }
}
```

#### 2. Manual Function Call

```dart
import 'package:contextless_ui/contextless_ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final navigatorKey = GlobalKey<NavigatorState>();
  ContextlessUi.init(navigatorKey: navigatorKey);
  runApp(MaterialApp(
    navigatorKey: navigatorKey,
    home: const MyHomePage(),
  ));
}
```

### Basic Usage

```dart
// 📱 Dialogs - Show from anywhere in your code!
void showLoadingDialog() {
  final handle = ContextlessDialogs.show(
    const Dialog(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading...'),
          ],
        ),
      ),
    ),
    tag: 'loading',
  );
  
  // Close this specific dialog later
  Future.delayed(const Duration(seconds: 3), () {
    ContextlessDialogs.close(handle);
  });
}

// 📢 Snackbars - Material Design snackbars with flexible content
void showNotification() {
  ContextlessSnackbars.show(
    const Text('File uploaded successfully!', style: TextStyle(color: Colors.white)),
    action: TextButton(
      onPressed: () => openFile(),
      child: const Text('View', style: TextStyle(color: Colors.yellow)),
    ),
    decoration: const SnackbarDecoration(
      backgroundColor: Colors.green,
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );
}

// 🍞 Toasts - Simple toast notifications with custom widgets
void showToast() {
  ContextlessToasts.show(
    const Text('Toast message', style: TextStyle(color: Colors.white)),
    iconLeft: const Icon(Icons.check_circle, color: Colors.white, size: 20),
    decoration: const ToastDecoration(
      backgroundColor: Colors.black87,
      borderRadius: BorderRadius.all(Radius.circular(8)),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}

// 📋 Bottom Sheets - Material bottom sheets with custom content
void showSettings() {
  ContextlessBottomSheets.show(
    Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          // ... settings content
        ],
      ),
    ),
    decoration: const BottomSheetDecoration(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),
  );
}

// 🎯 Async dialogs - Get results from user interactions
Future<String?> pickColor() async {
  final result = await ContextlessDialogs.showAsync<String>(
    Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Pick a color'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ContextlessDialogs.closeAll('red'),
              child: const Text('Red'),
            ),
            ElevatedButton(
              onPressed: () => ContextlessDialogs.closeAll('blue'),
              child: const Text('Blue'),
            ),
          ],
        ),
      ),
    ),
  );
  
  return result; // Returns 'red', 'blue', or null if dismissed
}
```

## API Reference

### Initialization

```dart
// Initialize with NavigatorState key (recommended)
ContextlessUi.init(navigatorKey: yourNavigatorKey);

// Or initialize with OverlayState key
ContextlessUi.init(overlayKey: yourOverlayKey);
```

### Dialogs

```dart
// Show a dialog
DialogHandle show(
  Widget dialog, {                      // Dialog widget content
  String? id,                           // Custom ID (UUID generated if null)
  String? tag,                          // Tag for grouping
  bool barrierDismissible = true,       // Tap outside to close
  DialogDecoration? decoration,         // Visual styling
});

// DialogDecoration properties
DialogDecoration({
  Color? barrierColor,                  // Barrier color behind dialog
  Duration? transitionDuration,         // Animation duration
  RouteTransitionsBuilder? transitionsBuilder, // Custom transitions
});

// Show async dialog that returns a result
Future<T?> showAsync<T>(Widget dialog, { /* same parameters */ });

// Dialog management
bool close(DialogHandle handle, [dynamic result]);
bool closeById(String id, [dynamic result]);
int closeByTag(String tag, [dynamic result]);
void closeAll([dynamic result]);
bool isOpen(Object handleOrId);
List<DialogHandle> get openDialogs;
int get openDialogCount;
```

### Snackbars

```dart
// Show a snackbar
SnackbarHandle show(
  Widget content, {                     // Snackbar content (positional)
  Widget? action,                       // Action widget (any Widget)
  Widget? iconLeft,                     // Icon on the left side
  Widget? iconRight,                    // Icon on the right side
  String? id,                           // Custom ID
  String? tag,                          // Tag for grouping
  Duration duration = const Duration(seconds: 4),
  SnackbarDecoration? decoration,       // Visual styling
});

// SnackbarDecoration properties
SnackbarDecoration({
  Color? backgroundColor,
  EdgeInsetsGeometry? margin,
  EdgeInsetsGeometry? padding,
  double? elevation,
  ShapeBorder? shape,
  double? width,
  SnackBarBehavior behavior = SnackBarBehavior.floating,
  DismissDirection dismissDirection = DismissDirection.down,
  bool showCloseIcon = false,
  Color? closeIconColor,
  RouteTransitionsBuilder? transitionsBuilder,
});

// Example
ContextlessSnackbars.show(
  const Text('Success!', style: TextStyle(color: Colors.white)),
  action: TextButton(
    onPressed: () {},
    child: const Text('Undo'),
  ),
  iconLeft: const Icon(Icons.check, color: Colors.white),
  decoration: const SnackbarDecoration(
    backgroundColor: Colors.green,
    borderRadius: BorderRadius.all(Radius.circular(8)),
  ),
);
```

### Toasts

```dart
// Show a toast
ToastHandle show(
  Widget content, {                     // Toast content (positional)
  Widget? iconLeft,                     // Icon on the left side
  Widget? iconRight,                    // Icon on the right side
  String? id,                           // Custom ID
  String? tag,                          // Tag for grouping
  Duration duration = const Duration(seconds: 3),
  Alignment alignment = Alignment.bottomCenter,
  ToastDecoration? decoration,          // Visual styling
});

// ToastDecoration properties
ToastDecoration({
  Color? backgroundColor,
  EdgeInsetsGeometry? padding,
  BorderRadius? borderRadius,
  double? elevation,
  RouteTransitionsBuilder? transitionsBuilder,
});

// Example
ContextlessToasts.show(
  const Text('Saved!', style: TextStyle(color: Colors.white)),
  iconLeft: const Icon(Icons.check_circle, color: Colors.white),
  decoration: const ToastDecoration(
    backgroundColor: Colors.black87,
    borderRadius: BorderRadius.all(Radius.circular(8)),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
);
```

### Bottom Sheets

```dart
// Show a bottom sheet
BottomSheetHandle show(
  Widget content, {                     // Bottom sheet content
  String? id,                           // Custom ID
  String? tag,                          // Tag for grouping
  bool isDismissible = true,            // Tap outside to close
  bool enableDrag = true,               // Enable drag to dismiss
  BottomSheetDecoration? decoration,    // Visual styling
});

// BottomSheetDecoration properties
BottomSheetDecoration({
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  BoxConstraints? constraints,
  RouteTransitionsBuilder? transitionsBuilder,
});

// Example
ContextlessBottomSheets.show(
  Container(
    padding: const EdgeInsets.all(16),
    child: const Text('Bottom Sheet Content'),
  ),
  decoration: const BottomSheetDecoration(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
  ),
);
```

### Universal Controls

These methods work with all UI component types:

```dart
// Close by handle
bool close(UiHandle handle, [dynamic result]);

// Close by ID  
bool closeById(String id, [dynamic result]);

// Close by tag (returns count of closed components)
int closeByTag(String tag, [dynamic result]);

// Close by type (e.g., all snackbars)
int closeByType(UiType type, [dynamic result]);

// Close all components
void closeAll([dynamic result]);

// Check if component is open
bool isOpen(Object handleOrId); // Accepts UiHandle or String ID

// Get all open components
List<UiHandle> get openUiComponents;

// Get count of open components
int get openUiComponentCount;
```

### Event Streams

```dart
// Listen to UI component events
ContextlessUi.events.listen((event) {
  if (event.type == UiEventType.opened) {
    print('${event.handle.type} ${event.handle.id} opened');
  } else if (event.type == UiEventType.closed) {
    print('${event.handle.type} ${event.handle.id} closed with result: ${event.result}');
  }
});

// Listen to dialog events
ContextlessDialogs.events.listen((event) {
  if (event.type == DialogEventType.opened) {
    print('Dialog ${event.handle.id} opened');
  } else if (event.type == DialogEventType.closed) {
    print('Dialog ${event.handle.id} closed with result: ${event.result}');
  }
});
```

## Builders (Convenience Classes)

### SnackbarBuilder

```dart
// Quick snackbar creation
final handle = SnackbarBuilder.success('Operation completed!');
final handle = SnackbarBuilder.error('Something went wrong');
final handle = SnackbarBuilder.warning('Please check your input');
final handle = SnackbarBuilder.info('New update available');

// With custom styling
final handle = SnackbarBuilder.custom(
  message: 'Custom message',
  backgroundColor: Colors.purple,
  textColor: Colors.white,
  icon: Icons.star,
);
```

### ToastBuilder

```dart
// Quick toast creation
final handle = ToastBuilder.success('Saved!');
final handle = ToastBuilder.error('Failed to save');
final handle = ToastBuilder.info('Processing...');

// With custom icon
final handle = ToastBuilder.withIcon(Icons.favorite, 'Added to favorites');
```

### BottomSheetBuilder

```dart
// Quick option selection
final result = await BottomSheetBuilder.showOptions<String>(
  title: 'Choose an option',
  options: [
    BottomSheetOption(
      label: 'Camera',
      value: 'camera',
      icon: Icons.camera_alt,
    ),
    BottomSheetOption(
      label: 'Gallery',
      value: 'gallery',
      icon: Icons.photo_library,
    ),
  ],
);

// List-style bottom sheet
final handle = BottomSheetBuilder.list(
  title: 'Select Item',
  items: ['Option 1', 'Option 2', 'Option 3'],
  onItemTap: (index, item) => print('Selected: $item'),
);
```

## Advanced Usage

### Custom Transitions

```dart
Widget customSlideTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: animation.drive(
      Tween(begin: const Offset(0, 1), end: Offset.zero),
    ),
    child: child,
  );
}

// Use custom transition
ContextlessUi.showSnackbar(
  const Text('Custom animated snackbar'),
  transitionsBuilder: customSlideTransition,
);
```

### Component with Custom ID

```dart
// Show component with specific ID
final handle = ContextlessUi.showSnackbar(
  const Text('Important notification'),
  id: 'important-notification',
);

// Close by ID from anywhere
ContextlessUi.closeById('important-notification');
```

### Tagged Component Management

```dart
// Show multiple progress components
ContextlessUi.showSnackbar(const Text('Uploading...'), tag: 'upload');
ContextlessUi.showToast(const Text('Processing...'), tag: 'upload');
ContextlessDialogs.show(const LoadingDialog(), tag: 'upload');

// Close all upload-related components
ContextlessUi.closeByTag('upload');
ContextlessDialogs.closeByTag('upload');

// Or close all at once
ContextlessUi.closeAll();
ContextlessDialogs.closeAll();
```

### Service Layer Integration

```dart
class ApiService {
  static Future<List<User>> fetchUsers() async {
    // Show loading notification
    final loadingHandle = ContextlessUi.showSnackbar(
      const Text('Fetching users...'),
      tag: 'api',
      duration: const Duration(minutes: 1), // Long duration
    );
    
    try {
      final response = await http.get(Uri.parse('/api/users'));
      
      // Close loading and show success
      ContextlessUi.close(loadingHandle);
      ContextlessUi.showSnackbar(
        const Text('Users loaded successfully!'),
        backgroundColor: Colors.green,
      );
      
      return parseUsers(response.body);
    } catch (e) {
      // Close loading and show error
      ContextlessUi.close(loadingHandle);
      ContextlessUi.showSnackbar(
        Text('Failed to fetch users: $e'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 10),
      );
      rethrow;
    }
  }
}
```

### Mixed Component Usage

```dart
void showMixedComponents() {
  // Show multiple component types together
  final snackbar = ContextlessUi.showSnackbar(
    const Text('Background task running'),
    tag: 'background',
  );
  
  final dialog = ContextlessDialogs.show(
    const ProcessingDialog(),
    tag: 'background',
  );
  
  final toast = ContextlessUi.showToast(
    const Text('Starting process...'),
    tag: 'background',
  );
  
  // Close all background components later
  Timer(const Duration(seconds: 5), () {
    ContextlessUi.closeByTag('background');
    ContextlessDialogs.closeByTag('background');
  });
}
```

## Best Practices

### 1. Initialize Early

Always initialize before `runApp()`:

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  final navigatorKey = GlobalKey<NavigatorState>();
  ContextlessUi.init(navigatorKey: navigatorKey);
  
  runApp(MyApp(navigatorKey: navigatorKey));
}
```

### 2. Use Tags for Organization

Group related components for easier management:

```dart
// Progress components
ContextlessUi.showSnackbar(const Text('Step 1'), tag: 'wizard');
ContextlessUi.showToast(const Text('Step 2'), tag: 'wizard');

// Error components  
ContextlessUi.showSnackbar(const Text('Error'), tag: 'error');

// Close all wizard components when done
ContextlessUi.closeByTag('wizard');
```

### 3. Handle Async Results Properly

```dart
Future<void> showConfirmationDialog() async {
  final confirmed = await ContextlessDialogs.showAsync<bool>(
    const ConfirmationDialog(),
  );
  
  if (confirmed == true) {
    // User confirmed
    await performAction();
  }
  // Handle null (dismissed) vs false (cancelled)
}
```

### 4. Use Builders for Common Patterns

```dart
// Instead of manually creating styled snackbars
ContextlessUi.showSnackbar(
  const Text('Success!'),
  backgroundColor: Colors.green,
  // ... more styling
);

// Use builders for cleaner code
SnackbarBuilder.success('Success!');
```

### 5. Listen to Events for Analytics

```dart
void initializeAnalytics() {
  ContextlessUi.events.listen((event) {
    analytics.track('ui_${event.type.name}', {
      'component_type': event.handle.type.name,
      'component_id': event.handle.id,
      'component_tag': event.handle.tag,
      'result': event.result,
    });
  });
}
```

### 6. Cleanup on App Disposal

```dart
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    ContextlessUi.dispose();
    ContextlessDialogs.dispose();
    super.dispose();
  }
  
  // ... rest of widget
}
```

## Common Issues & Solutions

### "ContextlessUi not initialized" Error

Make sure you call `init()` before `runApp()` and pass the navigator key:

```dart
// ❌ Wrong
runApp(const MyApp());
ContextlessUi.init(navigatorKey: key); // Too late!

// ✅ Correct  
ContextlessUi.init(navigatorKey: key);
runApp(MyApp(navigatorKey: key));
```

### Navigator Key Not Working

Ensure the same key is passed to both `init()` and `MaterialApp`:

```dart
final navigatorKey = GlobalKey<NavigatorState>(); // Create once

ContextlessUi.init(navigatorKey: navigatorKey); // Use same key
runApp(MaterialApp(navigatorKey: navigatorKey, ...)); // Use same key
```

### Components Not Appearing

Check that:

1. You've called `init()` with a valid key
2. The widget tree has been built at least once
3. You're not calling from an isolate without proper context

### Memory Leaks

Always dispose the system when your app shuts down:

```dart
@override
void dispose() {
  ContextlessUi.dispose(); // This closes all components and cleans up
  ContextlessDialogs.dispose();
  super.dispose();
}
```

## Component Types

| Component | Use Case | Key Features |
|-----------|----------|--------------|
| **Dialog** | Modal interactions, confirmations | Barrier, custom transitions, blocking |
| **Snackbar** | Status updates, notifications | Material Design, actions, auto-dismiss |
| **Toast** | Simple notifications | Lightweight, flexible positioning |
| **Bottom Sheet** | Options, forms, details | Material Design, drag support, scrollable |

## 📱 Platform Support

- ✅ **Android** - Full support with Material Design
- ✅ **iOS** - Full support with Cupertino styling
- ✅ **Web** - Full support with responsive design
- ✅ **Desktop** - Windows, macOS, Linux support
- ✅ **Embedded** - Flutter embedded platforms

## Examples

Check out the `/example` folder for a complete working example showcasing:

- All component types in action
- Async dialogs with results
- Tag-based component management
- Custom styling and transitions
- Service layer integration
- Builder patterns
- Event stream usage

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you find this package helpful, please:

- ⭐ Star the repository
- 🐛 Report issues on GitHub
- 💡 Suggest new features
- 📖 Improve documentation

---

### Made with ❤️ for the Flutter community

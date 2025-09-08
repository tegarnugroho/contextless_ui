# ContextlessUiInit Usage Guide

## Overview

`ContextlessUiInit` is a convenient widget wrapper that automatically handles the initialization of ContextlessUi and provides a clean builder pattern for setting up your app.

## Benefits

- **Automatic Initialization**: Handles `ContextlessUi.init()` and `ContextlessDialogs.init()` automatically
- **Lifecycle Management**: Proper widget lifecycle handling
- **Clean API**: Builder pattern for MaterialApp/CupertinoApp setup
- **Flexible**: Supports custom navigator keys and future configuration options

## Basic Usage

### Before (Manual Initialization)

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final navigatorKey = GlobalKey<NavigatorState>();
  ContextlessUi.init(navigatorKey: navigatorKey);
  runApp(MyApp(navigatorKey: navigatorKey));
}
```

### After (Using ContextlessUiInit)

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ContextlessUiInit(
      appBuilder: (context, navigatorKey, child) => MaterialApp(
        title: 'My App',
        navigatorKey: navigatorKey,
        home: child,
        // ... other MaterialApp properties
      ),
      child: const MyHomePage(),
    ),
  );
}
```

## Advanced Usage

### With Custom Navigator Key

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final customNavKey = GlobalKey<NavigatorState>();
  
  runApp(
    ContextlessUiInit(
      navigatorKey: customNavKey,
      appBuilder: (context, navigatorKey, child) => MaterialApp(
        navigatorKey: navigatorKey,
        home: child,
      ),
      child: const MyHomePage(),
    ),
  );
}
```

### With Future Configuration Options

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ContextlessUiInit(
      designSize: const Size(375, 812), // For responsive design
      appBuilder: (context, navigatorKey, child) => MaterialApp(
        navigatorKey: navigatorKey,
        home: child,
      ),
      child: const MyHomePage(),
    ),
  );
}
```

## Parameters

- `appBuilder`: Required. Function that builds your MaterialApp/CupertinoApp
- `child`: Optional. The main content widget (typically your home page)
- `navigatorKey`: Optional. Custom navigator key (auto-generated if not provided)
- `designSize`: Optional. For future responsive design configurations

## Why Use This Approach?

1. **Cleaner `main()` function**: No manual initialization code
2. **Better error handling**: Widget lifecycle ensures proper initialization
3. **Future-proof**: Easy to add new configuration options
4. **Testable**: Widget can be easily tested and mocked
5. **Consistent**: Standard Flutter widget patterns

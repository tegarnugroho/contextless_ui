import 'package:flutter/material.dart';
import 'contextless_ui_core.dart';
import 'ui_handle.dart';

/// Builder class for creating common bottom sheet types easily
class BottomSheetBuilder {
  BottomSheetBuilder._();

  /// Creates a simple bottom sheet with custom content
  /// 
  /// Example:
  /// ```dart
  /// BottomSheetBuilder.content(
  ///   Container(
  ///     height: 200,
  ///     child: Center(child: Text('Custom Content')),
  ///   ),
  /// );
  /// ```
  static UiHandle content(
    Widget content, {
    String? id,
    String? tag,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    BoxConstraints? constraints,
  }) {
    return ContextlessUi.showBottomSheet(
      content,
      id: id,
      tag: tag,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      constraints: constraints,
    );
  }

  /// Creates a list bottom sheet for selecting from options
  /// 
  /// Example:
  /// ```dart
  /// final result = await BottomSheetBuilder.listAsync<String>(
  ///   title: 'Choose an option',
  ///   options: [
  ///     BottomSheetOption('Option 1', 'value1'),
  ///     BottomSheetOption('Option 2', 'value2'),
  ///     BottomSheetOption('Option 3', 'value3'),
  ///   ],
  /// );
  /// ```
  static Future<T?> listAsync<T>(
    List<BottomSheetOption<T>> options, {
    String? title,
    String? id,
    String? tag,
    bool isDismissible = true,
    bool enableDrag = true,
    Widget? cancelButton,
  }) {
    return ContextlessUi.showBottomSheetAsync<T>(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(height: 1),
          ],
          // Options
          ...options.map((option) => ListTile(
                leading: option.icon,
                title: Text(option.title),
                subtitle: option.subtitle != null ? Text(option.subtitle!) : null,
              onTap: () {
                if (id != null) {
                  ContextlessUi.closeById(id, option.value);
                } else if (tag != null) {
                  ContextlessUi.closeByTag(tag, option.value);
                } else {
                  // Fallback: close all bottom sheets
                  ContextlessUi.closeByType(UiType.bottomSheet, option.value);
                }
              },
              )),
          // Cancel button
          if (cancelButton != null) ...[
            const Divider(height: 1),
            cancelButton,
          ] else if (isDismissible) ...[
            const Divider(height: 1),
            ListTile(
              title: const Text(
                'Cancel',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onTap: () {
                if (id != null) {
                  ContextlessUi.closeById(id);
                } else if (tag != null) {
                  ContextlessUi.closeByTag(tag);
                } else {
                  // Fallback: close all bottom sheets
                  ContextlessUi.closeByType(UiType.bottomSheet);
                }
              },
            ),
          ],
          // Bottom padding for safe area
          const SizedBox(height: 16),
        ],
      ),
      id: id,
      tag: tag,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
    );
  }

  /// Creates a confirmation bottom sheet
  /// 
  /// Example:
  /// ```dart
  /// final confirmed = await BottomSheetBuilder.confirmAsync(
  ///   title: 'Delete Item',
  ///   message: 'Are you sure you want to delete this item? This action cannot be undone.',
  ///   confirmText: 'Delete',
  ///   cancelText: 'Cancel',
  /// );
  /// if (confirmed == true) {
  ///   // User confirmed
  /// }
  /// ```
  static Future<bool?> confirmAsync({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    String? id,
    String? tag,
    bool isDismissible = true,
    Color? confirmColor,
    Color? cancelColor,
  }) {
    return ContextlessUi.showBottomSheetAsync<bool>(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Message
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      if (id != null) {
                        ContextlessUi.closeById(id, false);
                      } else if (tag != null) {
                        ContextlessUi.closeByTag(tag, false);
                      } else {
                        ContextlessUi.closeByType(UiType.bottomSheet, false);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cancelColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(cancelText),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (id != null) {
                        ContextlessUi.closeById(id, true);
                      } else if (tag != null) {
                        ContextlessUi.closeByTag(tag, true);
                      } else {
                        ContextlessUi.closeByType(UiType.bottomSheet, true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor ?? Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(confirmText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      id: id,
      tag: tag,
      isDismissible: isDismissible,
    );
  }

  /// Creates a form bottom sheet with text input
  /// 
  /// Example:
  /// ```dart
  /// final result = await BottomSheetBuilder.inputAsync(
  ///   title: 'Enter your name',
  ///   hintText: 'Name',
  ///   confirmText: 'Save',
  /// );
  /// ```
  static Future<String?> inputAsync({
    required String title,
    String? initialValue,
    String? hintText,
    String? labelText,
    String confirmText = 'Save',
    String cancelText = 'Cancel',
    String? id,
    String? tag,
    bool isDismissible = true,
    TextInputType? keyboardType,
    int? maxLines = 1,
    int? maxLength,
    bool obscureText = false,
  }) {
    final controller = TextEditingController(text: initialValue);
    
    return ContextlessUi.showBottomSheetAsync<String>(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Input field
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                labelText: labelText,
                border: const OutlineInputBorder(),
              ),
              keyboardType: keyboardType,
              maxLines: maxLines,
              maxLength: maxLength,
              obscureText: obscureText,
              autofocus: true,
            ),
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      if (id != null) {
                        ContextlessUi.closeById(id, null);
                      } else if (tag != null) {
                        ContextlessUi.closeByTag(tag, null);
                      } else {
                        ContextlessUi.closeByType(UiType.bottomSheet, null);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(cancelText),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final value = controller.text.trim();
                      if (id != null) {
                        ContextlessUi.closeById(id, value.isEmpty ? null : value);
                      } else if (tag != null) {
                        ContextlessUi.closeByTag(tag, value.isEmpty ? null : value);
                      } else {
                        ContextlessUi.closeByType(UiType.bottomSheet, value.isEmpty ? null : value);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(confirmText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      id: id,
      tag: tag,
      isDismissible: isDismissible,
      isScrollControlled: true,
    );
  }
}

/// Represents an option in a bottom sheet list
class BottomSheetOption<T> {
  /// The display title
  final String title;
  
  /// The value to return when selected
  final T value;
  
  /// Optional subtitle text
  final String? subtitle;
  
  /// Optional leading icon
  final Widget? icon;
  
  /// Creates a new bottom sheet option
  const BottomSheetOption(
    this.title,
    this.value, {
    this.subtitle,
    this.icon,
  });
}

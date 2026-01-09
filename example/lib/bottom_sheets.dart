import 'dart:async';
import 'package:flutter/material.dart';
import 'package:contextless_ui/contextless_ui.dart';
import 'demo_item.dart';

// Bottom Sheets
List<DialogDemo> get bottomSheetDemos => [
      DialogDemo(
        title: 'Option Selector',
        description: 'Choose from a list of options',
        icon: Icons.list_alt,
        color: const Color(0xFF0891B2),
        onTap: () => _showOptionsBottomSheet(),
      ),
      DialogDemo(
        title: 'Confirmation Sheet',
        description: 'Confirm user action',
        icon: Icons.help_outline,
        color: const Color(0xFFDC2626),
        onTap: () => _showConfirmationBottomSheet(),
      ),
      DialogDemo(
        title: 'Input Form',
        description: 'Collect user input',
        icon: Icons.edit,
        color: const Color(0xFF059669),
        onTap: () => _showInputBottomSheet(),
      ),
    ];

// Methods
void _showOptionsBottomSheet() async {
  final options = [
    {
      'title': 'Camera',
      'value': 'camera',
      'icon': const Icon(Icons.camera_alt)
    },
    {
      'title': 'Gallery',
      'value': 'gallery',
      'icon': const Icon(Icons.photo_library)
    },
    {'title': 'Files', 'value': 'files', 'icon': const Icon(Icons.folder)},
  ];

  final completer = Completer<String?>();
  BottomSheetHandle? handle;

  handle = ContextlessBottomSheets.show(
    Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Select Source',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...options.map((option) => ListTile(
                leading: option['icon'] as Widget,
                title: Text(option['title'] as String),
                onTap: () {
                  completer.complete(option['value'] as String);
                  handle?.close();
                },
              )),
        ],
      ),
    ),
    decoration: const BottomSheetDecoration(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),
  );

  final result = await completer.future;
  if (result != null) {
    ContextlessToasts.show(Text('Selected: $result'));
  }
}

void _showConfirmationBottomSheet() async {
  final completer = Completer<bool?>();
  ContextlessBottomSheets.show(
    Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Clear Cache',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text(
              'This will clear all cached data and free up storage space. Continue?'),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    completer.complete(false);
                    ContextlessBottomSheets.closeByTag('confirm-clear-cache');
                  },
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  onPressed: () {
                    completer.complete(true);
                    ContextlessBottomSheets.closeByTag('confirm-clear-cache');
                  },
                  child: const Text('Clear',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    decoration: const BottomSheetDecoration(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),
    tag: 'confirm-clear-cache',
  );

  final confirmed = await completer.future;
  if (confirmed == true) {
    ContextlessToasts.show(
      const Text('Cache cleared successfully!',
          style: TextStyle(color: Colors.white)),
      iconLeft: const Icon(Icons.check_circle, color: Colors.white),
      decoration: const ToastDecoration(
        backgroundColor: Colors.green,
      ),
    );
  }
}

void _showInputBottomSheet() async {
  final completer = Completer<String?>();
  final textController = TextEditingController();
  BottomSheetHandle? handle;

  handle = ContextlessBottomSheets.show(
    Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Add Note',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextField(
            controller: textController,
            decoration: const InputDecoration(
              hintText: 'Enter your note...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            autofocus: true,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    completer.complete(null);
                    handle?.close();
                  },
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    completer.complete(textController.text);
                    handle?.close();
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    decoration: const BottomSheetDecoration(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    ),
  );

  final result = await completer.future;
  if (result != null && result.isNotEmpty) {
    ContextlessToasts.show(
      Text('Note saved: $result'),
      iconLeft: const Icon(Icons.check_circle, color: Colors.white),
      decoration: const ToastDecoration(
        backgroundColor: Colors.green,
      ),
    );
  }
}

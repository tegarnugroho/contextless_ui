import 'package:flutter/material.dart';

extension ColorExtension on Color? {
  // NEW: Determine readable text color automatically
  Color get autoTextOn {
    final color = this;
    if (color != null) {
      // If the background is light, use black; otherwise, use white
      return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    }
    // Fallback: follow platform brightness
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark ? Colors.black : Colors.white;
  }
}

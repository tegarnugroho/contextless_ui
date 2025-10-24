import 'package:flutter/material.dart';

class AppTheme {
  // Base color palette
  static const Color _seed = Color(0xFF6366F1); // indigo
  static const Color _accent = Color(0xFF0EA5A4); // teal
  static const Color _warn = Color(0xFFF59E0B); // amber

  static ThemeData get light {
    final cs = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs.copyWith(
        secondary: _accent,
        tertiary: const Color(0xFF8B5CF6), // violet
      ),
      scaffoldBackgroundColor: cs.surface,

      // Slightly bolder typography for better emphasis
      textTheme: _textTheme(Brightness.light, cs),

      // Minimalist AppBar with no elevation
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: cs.onSurface,
        titleTextStyle: _textTheme(Brightness.light, cs).titleLarge,
      ),

      // Button styles
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 44),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 44),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: cs.tertiaryContainer,
          foregroundColor: cs.onTertiaryContainer,
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cs.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: cs.surfaceContainerHighest,
        hintStyle: TextStyle(color: cs.onSurfaceVariant),
        border: _inputBorder(cs),
        enabledBorder: _inputBorder(cs),
        focusedBorder: _inputBorder(cs, focused: true),
        errorBorder: _inputBorder(cs, error: true),
        focusedErrorBorder: _inputBorder(cs, focused: true, error: true),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),

      // Card style
      cardTheme: CardThemeData(
        color: cs.surfaceContainerHigh,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        backgroundColor: cs.surface,
        surfaceTintColor: cs.surfaceTint,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // Bottom sheets
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cs.surface,
        surfaceTintColor: cs.surfaceTint,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        showDragHandle: true,
        dragHandleColor: cs.outlineVariant,
      ),

      // Snackbars
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: cs.inverseSurface,
        contentTextStyle: TextStyle(color: cs.onInverseSurface),
        actionTextColor: cs.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),

      // Chips, ListTiles, Icons, Dividers
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: cs.outlineVariant),
        backgroundColor: cs.surfaceContainerHigh,
        selectedColor: cs.secondaryContainer,
        labelStyle: TextStyle(color: cs.onSurface),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: cs.surfaceContainerHighest,
        selectedTileColor: cs.secondaryContainer,
        iconColor: cs.secondary,
      ),
      iconTheme: IconThemeData(color: cs.onSurfaceVariant),
      dividerTheme: DividerThemeData(
        color: cs.outlineVariant,
        thickness: 1,
        space: 24,
      ),

      // Smooth page transitions
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static ThemeData get dark {
    final cs = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: cs.copyWith(
        secondary: _accent,
        tertiary: const Color(0xFF8B5CF6),
      ),
      scaffoldBackgroundColor: cs.surface,
      textTheme: _textTheme(Brightness.dark, cs),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: cs.onSurface,
        titleTextStyle: _textTheme(Brightness.dark, cs).titleLarge,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 44),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 44),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: cs.tertiaryContainer,
          foregroundColor: cs.onTertiaryContainer,
          elevation: 0,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cs.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        filled: true,
        fillColor: cs.surfaceContainerHigh,
        hintStyle: TextStyle(color: cs.onSurfaceVariant),
        border: _inputBorder(cs),
        enabledBorder: _inputBorder(cs),
        focusedBorder: _inputBorder(cs, focused: true),
        errorBorder: _inputBorder(cs, error: true),
        focusedErrorBorder: _inputBorder(cs, focused: true, error: true),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      cardTheme: CardThemeData(
        color: cs.surfaceContainerHigh,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cs.surface,
        surfaceTintColor: cs.surfaceTint,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cs.surface,
        surfaceTintColor: cs.surfaceTint,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        showDragHandle: true,
        dragHandleColor: cs.outlineVariant,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: cs.inverseSurface,
        contentTextStyle: TextStyle(color: cs.onInverseSurface),
        actionTextColor: _warn,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: BorderSide(color: cs.outlineVariant),
        backgroundColor: cs.surfaceContainerHigh,
        selectedColor: cs.secondaryContainer,
        labelStyle: TextStyle(color: cs.onSurface),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: cs.surfaceContainerHighest,
        selectedTileColor: cs.secondaryContainer,
        iconColor: cs.secondary,
      ),
      iconTheme: IconThemeData(color: cs.onSurfaceVariant),
      dividerTheme: DividerThemeData(
        color: cs.outlineVariant,
        thickness: 1,
        space: 24,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static OutlineInputBorder _inputBorder(ColorScheme cs,
      {bool focused = false, bool error = false}) {
    final color = error ? cs.error : (focused ? cs.primary : cs.outlineVariant);
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: focused ? 1.4 : 1),
    );
  }

  static TextTheme _textTheme(Brightness b, ColorScheme cs) {
    final base = b == Brightness.dark
        ? Typography.whiteMountainView
        : Typography.blackMountainView;
    return base.copyWith(
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: base.bodyLarge?.copyWith(height: 1.35),
      bodyMedium: base.bodyMedium?.copyWith(
        color: cs.onSurfaceVariant,
        height: 1.4,
      ),
      labelLarge: base.labelLarge?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

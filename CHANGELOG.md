# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.1] - 2026-09-30

### Fixed

- **Snackbar Swipe Dismissal Assertion**: Fixed `A dismissed Dismissible widget is still part of the tree` assertion error by tracking dismissal state in `_SnackbarWrapper` and immediately unmounting the `Dismissible` widget upon gesture completion without delaying for an exit animation.
- **Unique Dismissible Keys**: Generated unique keys per snackbar instance to prevent widget state recycling errors.
- **Timer Management**: Ensured auto-dismiss timers are cancelled on component close or dispose to prevent resource leaks and pending timer test failures.
- **Bottom Sheet `ListTile` Assertion**: Fixed `ListTile background color or ink splashes may be invisible` error by providing a real non-transparent `Material` canvas surface with `clipBehavior: Clip.antiAlias` and proper elevation.
- **Overlay Entry Unmounting**: Added mounted checks before removing overlay entries to prevent unmounted removal exceptions during rapid close operations.
- **Text & Icon Contrast**: Integrated automatic `DefaultTextStyle` and `IconTheme` into both snackbar and toast wrappers, adapting text and icon colors dynamically based on background luminance (e.g. crisp white text/icons on dark backgrounds).

### Improved

- **Example UI Redesign**:
  - Completely redesigned `ColorPickerDialog` with modern squircle color tiles, subtle gradients, and ambient glow.
  - Revamped `UserInputDialog` ("Create Account") with Material 3 inputs, styled rounded borders, and icon badges.
  - Upgraded `DeleteConfirmationDialog` with danger aura indicator, connected services preview card, and clear action buttons.
  - Adjusted color contrast across example snackbars, toasts, and loading dialogs for optimal legibility.

## [0.1.0] - 2024-12-19

### Added

- Initial release of contextless_ui package

library contextless_ui;

// Export the unified core that handles all UI components
export 'src/contextless_ui_unified_core.dart';

// Export individual cores for direct access
export 'src/dialogs/contextless_dialogs_core.dart';
export 'src/toast/contextless_toast_core.dart';
export 'src/bottomsheet/contextless_bottomsheet_core.dart';
export 'src/snackbar/contextless_snackbar_core.dart';

// Export handles
export 'src/dialogs/dialog_handle.dart' show DialogHandle;
export 'src/toast/toast_handle.dart' show ToastHandle;
export 'src/bottomsheet/bottomsheet_handle.dart' show BottomSheetHandle;
export 'src/snackbar/snackbar_handle.dart' show SnackbarHandle;

// Export transitions
export 'src/dialogs/dialog_transitions.dart' show DialogTransitions;
export 'src/toast/toast_transitions.dart' show ToastTransitions;
export 'src/bottomsheet/bottomsheet_transitions.dart' show BottomSheetTransitions;
export 'src/snackbar/snackbar_transitions.dart' show SnackbarTransitions;

// Export observer for legacy compatibility
export 'src/core/common/contextless_observer.dart' show ContextlessObserver;

// Export base components for advanced customization
export 'src/core/base/base_handle.dart' show BaseHandle;
export 'src/core/base/base_components.dart' show BaseOverlayManager, BaseController;

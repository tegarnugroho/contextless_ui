library contextless_ui;

// Export the unified core that handles all UI components
export 'src/contextless_ui_unified_core.dart';

// Export individual component cores for backward compatibility
export 'src/widgets/snackbar/contextless_snackbar_core.dart' show ContextlessSnackbars;
export 'src/widgets/toast/contextless_toast_core.dart' show ContextlessToasts;
export 'src/widgets/dialogs/contextless_dialogs_core.dart' show ContextlessDialogs;
export 'src/widgets/bottomsheet/contextless_bottomsheet_core.dart' show ContextlessBottomSheets;

// Export handles
export 'src/widgets/dialogs/dialog_handle.dart' show DialogHandle;
export 'src/widgets/toast/toast_handle.dart' show ToastHandle;
export 'src/widgets/bottomsheet/bottomsheet_handle.dart' show BottomSheetHandle;
export 'src/widgets/snackbar/snackbar_handle.dart' show SnackbarHandle;
// Export models
export 'src/widgets/snackbar/snackbar_decoration.dart';
export 'src/widgets/toast/toast_decoration.dart';
export 'src/widgets/dialogs/dialog_decoration.dart';
export 'src/widgets/bottomsheet/bottomsheet_decoration.dart';

// Export transitions
export 'src/widgets/dialogs/dialog_transitions.dart' show DialogTransitions;
export 'src/widgets/toast/toast_transitions.dart' show ToastTransitions;
export 'src/widgets/bottomsheet/bottomsheet_transitions.dart'
    show BottomSheetTransitions;
export 'src/widgets/snackbar/snackbar_transitions.dart'
    show SnackbarTransitions;

// Export observer for legacy compatibility
export 'src/core/common/contextless_observer.dart' show ContextlessObserver;

// Export base components for advanced customization
export 'src/core/base/base_handle.dart' show BaseHandle;
export 'src/core/base/base_components.dart'
    show BaseOverlayManager, BaseController;

// Export the unified core class for centralized management
export 'src/contextless_ui_unified_core.dart' show ContextlessUi;

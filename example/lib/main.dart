import 'package:flutter/material.dart';
import 'dart:async';
import 'package:contextless_ui/contextless_ui.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Create a global navigator key to be used by the contextless UI system
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // Initialize the contextless UI system
    ContextlessUi.init(navigatorKey: navigatorKey);
    
    return MaterialApp(
      title: 'Contextless UI',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.only(bottom: 12),
        ),
      ),
      navigatorKey: navigatorKey,
      navigatorObservers: [
        ContextlessObserver(),
      ],
      home: const MyHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  String _lastResult = 'No result yet';
  int _openDialogCount = 0;

  @override
  void initState() {
    super.initState();
    // Note: In the new API, we don't have global event streams
    // Each component can be tracked individually using their handles
  }

  // Note: In the new API, we don't need to dispose event subscriptions
  // since we're not using global event streams anymore

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Contextless UI',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Header
              _buildStatusHeader(),
              const SizedBox(height: 32),

              // Sections
              _buildSection('Basic Dialogs', _basicDialogs),
              const SizedBox(height: 24),
              _buildSection('Interactive Dialogs', _interactiveDialogs),
              const SizedBox(height: 24),
              _buildSection('Snackbars', _snackbarDemos),
              const SizedBox(height: 24),
              _buildSection('Bottom Sheets', _bottomSheetDemos),
              const SizedBox(height: 24),
              _buildSection('Toasts', _toastDemos),
              const SizedBox(height: 24),
              _buildSection('Advanced Features', _advancedFeatures),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _openDialogCount > 0
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.layers_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$_openDialogCount Active Dialogs',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  _lastResult,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          if (_openDialogCount > 0)
            FilledButton(
              onPressed: () => ContextlessDialogs.closeAll(),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
                minimumSize: const Size(0, 40),
              ),
              child: const Text('Close All'),
            ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<_DialogDemo> demos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 16),
        ...demos.map((demo) => _buildDemoCard(demo)),
      ],
    );
  }

  Widget _buildDemoCard(_DialogDemo demo) {
    return Card(
      child: InkWell(
        onTap: demo.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: demo.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  demo.icon,
                  color: demo.color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      demo.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      demo.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.outline,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Demo data
  List<_DialogDemo> get _basicDialogs => [
        _DialogDemo(
          title: 'Welcome Message',
          description: 'Show a welcome dialog without context',
          icon: Icons.waving_hand,
          color: const Color(0xFF3B82F6),
          onTap: () => _showWelcomeDialog(),
        ),
        _DialogDemo(
          title: 'Loading Process',
          description: 'Display loading with auto-close',
          icon: Icons.hourglass_empty,
          color: const Color(0xFFF59E0B),
          onTap: () => _showProcessingDialog(),
        ),
      ];

  List<_DialogDemo> get _interactiveDialogs => [
        _DialogDemo(
          title: 'Color Selection',
          description: 'Pick a color from the palette',
          icon: Icons.palette_outlined,
          color: const Color(0xFF8B5CF6),
          onTap: () => _showColorPicker(),
        ),
        _DialogDemo(
          title: 'User Registration',
          description: 'Collect user information with validation',
          icon: Icons.person_add_outlined,
          color: const Color(0xFF059669),
          onTap: () => _showUserInputDialog(),
        ),
        _DialogDemo(
          title: 'Delete Confirmation',
          description: 'Confirm account deletion',
          icon: Icons.delete_outline,
          color: const Color(0xFFDC2626),
          onTap: () => _showConfirmationDialog(),
        ),
      ];

  List<_DialogDemo> get _snackbarDemos => [
        _DialogDemo(
          title: 'Success Message',
          description: 'Show success notification',
          icon: Icons.check_circle_outline,
          color: const Color(0xFF16A34A),
          onTap: () =>
              SnackbarBuilder.success('Operation completed successfully!'),
        ),
        _DialogDemo(
          title: 'Error Alert',
          description: 'Display error message',
          icon: Icons.error_outline,
          color: const Color(0xFFDC2626),
          onTap: () => SnackbarBuilder.error('Something went wrong!'),
        ),
        _DialogDemo(
          title: 'Loading Progress',
          description: 'Show loading snackbar',
          icon: Icons.hourglass_empty,
          color: const Color(0xFFF59E0B),
          onTap: () => _showLoadingSnackbar(),
        ),
        _DialogDemo(
          title: 'Action Required',
          description: 'Snackbar with user action',
          icon: Icons.touch_app,
          color: const Color(0xFF8B5CF6),
          onTap: () => _showActionSnackbar(),
        ),
      ];

  List<_DialogDemo> get _bottomSheetDemos => [
        _DialogDemo(
          title: 'Option Selector',
          description: 'Choose from a list of options',
          icon: Icons.list_alt,
          color: const Color(0xFF0891B2),
          onTap: () => _showOptionsBottomSheet(),
        ),
        _DialogDemo(
          title: 'Confirmation Sheet',
          description: 'Confirm user action',
          icon: Icons.help_outline,
          color: const Color(0xFFDC2626),
          onTap: () => _showConfirmationBottomSheet(),
        ),
        _DialogDemo(
          title: 'Input Form',
          description: 'Collect user input',
          icon: Icons.edit_outlined,
          color: const Color(0xFF059669),
          onTap: () => _showInputBottomSheet(),
        ),
      ];

  List<_DialogDemo> get _toastDemos => [
        _DialogDemo(
          title: 'Simple Message',
          description: 'Basic toast notification',
          icon: Icons.message_outlined,
          color: const Color(0xFF6B7280),
          onTap: () => ToastBuilder.text('Hello World!'),
        ),
        _DialogDemo(
          title: 'Success Toast',
          description: 'Success notification toast',
          icon: Icons.check_circle_outline,
          color: const Color(0xFF16A34A),
          onTap: () => ToastBuilder.success('Task completed successfully!'),
        ),
        _DialogDemo(
          title: 'Custom Toast',
          description: 'Toast with custom icon',
          icon: Icons.favorite_outline,
          color: const Color(0xFFEC4899),
          onTap: () => ToastBuilder.withIcon(
              Icons.favorite, 'Added to favorites',
              backgroundColor: Colors.pink),
        ),
        _DialogDemo(
          title: 'Progress Toast',
          description: 'Toast with progress indicator',
          icon: Icons.download_outlined,
          color: const Color(0xFF3B82F6),
          onTap: () => _showProgressToast(),
        ),
      ];

  List<_DialogDemo> get _advancedFeatures => [
        _DialogDemo(
          title: 'Multiple Dialogs',
          description: 'Manage several dialogs with tags',
          icon: Icons.layers_outlined,
          color: const Color(0xFF0891B2),
          onTap: () => _showMultipleDialogs(),
        ),
        _DialogDemo(
          title: 'Custom Animations',
          description: 'Showcase different transitions',
          icon: Icons.animation,
          color: const Color(0xFF4F46E5),
          onTap: () => _showCustomTransitions(),
        ),
        _DialogDemo(
          title: 'Background Service',
          description: 'Dialog from service layer',
          icon: Icons.cloud_outlined,
          color: const Color(0xFF0D9488),
          onTap: () => _simulateServiceCall(),
        ),
        _DialogDemo(
          title: 'Mixed UI Components',
          description: 'Show multiple UI types together',
          icon: Icons.dashboard_outlined,
          color: const Color(0xFF7C3AED),
          onTap: () => _showMixedComponents(),
        ),
      ];

  // Dialog implementations
  void _showWelcomeDialog() {
    ContextlessDialogs.show(
      const WelcomeDialog(),
      tag: 'welcome',
    );
  }

  void _showProcessingDialog() {
    final handle = ContextlessDialogs.show(
      const ProcessingDialog(),
      tag: 'processing',
      barrierDismissible: false,
    );

    // Auto close after 3 seconds
    Timer(const Duration(seconds: 3), () {
      ContextlessDialogs.close(handle, 'completed');
      _showSuccessMessage('Process completed successfully');
    });
  }

  void _showColorPicker() async {
    final color = await ContextlessDialogs.showAsync<Color>(
      const ColorPickerDialog(),
      tag: 'picker',
    );

    if (color != null) {
      _showSuccessMessage('Selected ${_colorName(color)}');
    }
  }

  void _showUserInputDialog() async {
    final result = await ContextlessDialogs.showAsync<Map<String, String>>(
      const UserInputDialog(),
      tag: 'input',
    );

    if (result != null) {
      _showSuccessMessage('Welcome ${result['name']}!');
    }
  }

  void _showConfirmationDialog() async {
    final result = await ContextlessDialogs.showAsync<bool>(
      const DeleteConfirmationDialog(),
      tag: 'confirm',
    );

    if (result == true) {
      _showSuccessMessage('Account deletion confirmed');
    } else if (result == false) {
      _showSuccessMessage('Account deletion cancelled');
    }
  }

  void _showMultipleDialogs() {
    for (int i = 1; i <= 3; i++) {
      ContextlessDialogs.show(
        TaskDialog(
          taskNumber: i,
          onClose: () => ContextlessDialogs.closeByTag('task-$i'),
        ),
        tag: 'task-$i',
        id: 'multi-$i',
      );
    }
  }

  void _showCustomTransitions() {
    final transitions = [
      ('Slide from Bottom', DialogTransitions.slideFromBottom),
      ('Slide from Top', DialogTransitions.slideFromTop),
      ('Scale Animation', DialogTransitions.scale),
      ('Fade Animation', DialogTransitions.fade),
      ('Fade + Scale', DialogTransitions.fadeWithScale),
    ];

    for (int i = 0; i < transitions.length; i++) {
      final (name, transition) = transitions[i];
      Timer(Duration(milliseconds: i * 400), () {
        ContextlessDialogs.show(
          TransitionDemo(name: name),
          tag: 'transitions',
          transitionsBuilder: transition,
        );
      });
    }
  }

  void _simulateServiceCall() {
    _showSuccessMessage('Starting background service...');

    Timer(const Duration(seconds: 1), () {
      BackgroundService.processData();
    });
  }

  // Snackbar methods
  void _showLoadingSnackbar() {
    final handle = SnackbarBuilder.loading('Processing your request...');
    Timer(const Duration(seconds: 3), () {
      handle.close();
      SnackbarBuilder.success('Processing completed!');
    });
  }

  void _showActionSnackbar() async {
    final result = await SnackbarBuilder.actionAsync<bool>(
      'Delete this item?',
      actionLabel: 'DELETE',
      actionValue: true,
      id: 'delete-snackbar',
      backgroundColor: Colors.red,
      actionTextColor: Colors.white,
      duration: const Duration(seconds: 6),
    );

    if (result == true) {
      SnackbarBuilder.success('Item deleted successfully!');
    }
  }

  // Bottom sheet methods
  void _showOptionsBottomSheet() async {
    final options = [
      const BottomSheetOption('Camera', 'camera', icon: Icon(Icons.camera_alt)),
      const BottomSheetOption('Gallery', 'gallery',
          icon: Icon(Icons.photo_library)),
      const BottomSheetOption('Files', 'files', icon: Icon(Icons.folder)),
    ];

    final result = await BottomSheetBuilder.listAsync<String>(
      options,
      title: 'Select Source',
    );

    if (result != null) {
      ToastBuilder.success('Selected: $result');
    }
  }

  void _showConfirmationBottomSheet() async {
    final confirmed = await BottomSheetBuilder.confirmAsync(
      title: 'Clear Cache',
      message:
          'This will clear all cached data and free up storage space. Continue?',
      confirmText: 'Clear',
      cancelText: 'Cancel',
      confirmColor: Colors.orange,
    );

    if (confirmed == true) {
      ToastBuilder.success('Cache cleared successfully!');
    }
  }

  void _showInputBottomSheet() async {
    final result = await BottomSheetBuilder.inputAsync(
      title: 'Add Note',
      hintText: 'Enter your note...',
      confirmText: 'Save',
      maxLines: 3,
    );

    if (result != null && result.isNotEmpty) {
      ToastBuilder.success('Note saved: $result');
    }
  }

  // Toast methods
  void _showProgressToast() {
    double progress = 0.0;
    ToastHandle? currentHandle;

    void updateProgress() {
      // Close previous toast if exists
      if (currentHandle != null) {
        currentHandle!.close();
      }

      // Show new progress toast
      currentHandle = ToastBuilder.progress(
        'Downloading...',
        progress: progress,
        id: 'download-${DateTime.now().millisecondsSinceEpoch}', // Unique ID
      );
    }

    updateProgress(); // Initial toast

    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      progress += 0.1;
      if (progress >= 1.0) {
        timer.cancel();
        if (currentHandle != null) {
          currentHandle!.close();
        }
        ToastBuilder.success('Download completed!');
      } else {
        updateProgress();
      }
    });
  }

  // Mixed components
  void _showMixedComponents() {
    // Show a combination of different UI components
    ToastBuilder.info('Starting multi-component demo...');

    Timer(const Duration(milliseconds: 500), () {
      SnackbarBuilder.warning('Please wait while we prepare your content');
    });

    Timer(const Duration(seconds: 2), () async {
      final result = await BottomSheetBuilder.confirmAsync(
        title: 'Ready!',
        message: 'Your content is ready. Would you like to view it now?',
        confirmText: 'View',
        cancelText: 'Later',
      );

      if (result == true) {
        ContextlessDialogs.show(
          const WelcomeDialog(),
          tag: 'mixed-demo',
        );
      }
    });
  }

  void _showSuccessMessage(String message) {
    SnackbarBuilder.success(message);
  }

  String _colorName(Color color) {
    if (color == Colors.red) return 'Red';
    if (color == Colors.green) return 'Green';
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.purple) return 'Purple';
    if (color == Colors.orange) return 'Orange';
    if (color == Colors.yellow) return 'Yellow';
    return 'Unknown Color';
  }
}

// Dialog demo data class
class _DialogDemo {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DialogDemo({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

// Welcome Dialog
class WelcomeDialog extends StatelessWidget {
  const WelcomeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.rocket_launch,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to Contextless Dialogs',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'This dialog was created without requiring any BuildContext. Perfect for service layers and background processes.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => ContextlessDialogs.closeAll('understood'),
                child: const Text('Got it'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Processing Dialog
class ProcessingDialog extends StatelessWidget {
  const ProcessingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Processing your request',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please wait a moment...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// Color Picker Dialog
class ColorPickerDialog extends StatelessWidget {
  const ColorPickerDialog({super.key});

  final List<({Color color, String name})> colors = const [
    (color: Colors.red, name: 'Red'),
    (color: Colors.green, name: 'Green'),
    (color: Colors.blue, name: 'Blue'),
    (color: Colors.purple, name: 'Purple'),
    (color: Colors.orange, name: 'Orange'),
    (color: Colors.yellow, name: 'Yellow'),
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose a Color',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: colors.length,
              itemBuilder: (context, index) {
                final colorInfo = colors[index];
                return ColorButton(
                  color: colorInfo.color,
                  name: colorInfo.name,
                );
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => ContextlessDialogs.closeAll(),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ColorButton extends StatelessWidget {
  final Color color;
  final String name;

  const ColorButton({
    super.key,
    required this.color,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ContextlessDialogs.closeAll(color),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            name,
            style: TextStyle(
              color: _getTextColor(color),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Color _getTextColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }
}

// User Input Dialog
class UserInputDialog extends StatefulWidget {
  const UserInputDialog({super.key});

  @override
  State<UserInputDialog> createState() => _UserInputDialogState();
}

class _UserInputDialogState extends State<UserInputDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Account',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please fill in your information',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => ContextlessDialogs.closeAll(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: _submit,
                      child: const Text('Create'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      ContextlessDialogs.closeAll({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
      });
    }
  }
}

// Delete Confirmation Dialog
class DeleteConfirmationDialog extends StatelessWidget {
  const DeleteConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App icons row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.shopping_bag,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_taxi,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Text(
              'Delete account across apps?',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            Text(
              'Once deleted, you\'ll lose access to the account and saved details across all connected apps.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => ContextlessDialogs.closeAll(false),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () => ContextlessDialogs.closeAll(true),
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      foregroundColor: Theme.of(context).colorScheme.onError,
                    ),
                    child: const Text('Proceed'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Task Dialog for multiple dialogs demo
class TaskDialog extends StatelessWidget {
  final int taskNumber;
  final VoidCallback onClose;

  const TaskDialog({
    super.key,
    required this.taskNumber,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Text(
                '$taskNumber',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Task #$taskNumber',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'This is an example of managing multiple dialogs with different tags.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onClose,
              child: const Text('Close This Task'),
            ),
          ],
        ),
      ),
    );
  }
}

// Transition Demo Dialog
class TransitionDemo extends StatelessWidget {
  final String name;

  const TransitionDemo({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.animation,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'This dialog uses the $name transition.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => ContextlessDialogs.closeByTag('transitions'),
              child: const Text('Close All Transitions'),
            ),
          ],
        ),
      ),
    );
  }
}

// Background Service
class BackgroundService {
  static void processData() {
    Timer(const Duration(seconds: 2), () {
      ContextlessDialogs.show(
        const ServiceNotificationDialog(),
        tag: 'service',
      );
    });
  }
}

// Service Notification Dialog
class ServiceNotificationDialog extends StatelessWidget {
  const ServiceNotificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(
                Icons.cloud_done,
                size: 48,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Service Completed',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Background service completed successfully! This dialog was shown from a service layer without any BuildContext.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => ContextlessDialogs.closeByTag('service'),
                child: const Text('Awesome!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

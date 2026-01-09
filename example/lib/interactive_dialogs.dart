import 'package:flutter/material.dart';
import 'package:contextless_ui/contextless_ui.dart';
import 'demo_item.dart';

// Interactive Dialogs
List<DialogDemo> get interactiveDialogs => [
      DialogDemo(
        title: 'Color Selection',
        description: 'Pick a color from the palette',
        icon: Icons.palette_outlined,
        color: const Color(0xFF8B5CF6),
        onTap: () => _showColorPicker(),
      ),
      DialogDemo(
        title: 'User Registration',
        description: 'Collect user information with validation',
        icon: Icons.person_add_outlined,
        color: const Color(0xFF059669),
        onTap: () => _showUserInputDialog(),
      ),
      DialogDemo(
        title: 'Delete Confirmation',
        description: 'Confirm account deletion',
        icon: Icons.delete_outline,
        color: const Color(0xFFDC2626),
        onTap: () => _showConfirmationDialog(),
      ),
    ];

// Methods
void _showColorPicker() async {
  final color = await ContextlessUi.showDialogAsync<Color>(
    const ColorPickerDialog(),
    tag: 'picker',
  );

  if (color != null) {
    _showSuccessMessage('Selected color: ${_colorName(color)}');
  }
}

void _showUserInputDialog() async {
  final result = await ContextlessUi.showDialogAsync<Map<String, String>>(
    const UserInputDialog(),
    tag: 'user-input',
  );

  if (result != null) {
    _showSuccessMessage('Welcome, ${result['name']}!');
  }
}

void _showConfirmationDialog() async {
  final confirmed = await ContextlessUi.showDialogAsync<bool>(
    const DeleteConfirmationDialog(),
    tag: 'confirm-delete',
  );

  if (confirmed == true) {
    _showSuccessMessage('Account deleted successfully');
  }
}

void _showSuccessMessage(String message) {
  ContextlessUi.showSnackbar(
    Text(message),
    iconLeft: const Icon(Icons.check_circle),
    decoration: const SnackbarDecoration(
      backgroundColor: Colors.green,
    ),
  );
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
                onPressed: () => ContextlessUi.closeAllDialogs(),
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

  const ColorButton({super.key, required this.color, required this.name});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ContextlessUi.closeAllDialogs(color),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 2),
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
                      onPressed: () => ContextlessUi.closeAllDialogs(),
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
      ContextlessUi.closeAllDialogs({
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
                  child: const Icon(Icons.restaurant,
                      color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.shopping_bag,
                      color: Colors.white, size: 16),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.local_taxi,
                      color: Colors.white, size: 16),
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
                    onPressed: () => ContextlessUi.closeAllDialogs(false),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () => ContextlessUi.closeAllDialogs(true),
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

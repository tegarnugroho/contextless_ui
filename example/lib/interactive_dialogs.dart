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
    Text(
      message,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    ),
    iconLeft: const Icon(Icons.check_circle, color: Colors.white),
    decoration: const SnackbarDecoration(
      backgroundColor: Color(0xFF16A34A),
    ),
  );
}

String _colorName(Color color) {
  if (color == const Color(0xFFEF4444) || color == Colors.red) return 'Crimson';
  if (color == const Color(0xFF10B981) || color == Colors.green) return 'Emerald';
  if (color == const Color(0xFF3B82F6) || color == Colors.blue) return 'Azure';
  if (color == const Color(0xFF8B5CF6) || color == Colors.purple) return 'Violet';
  if (color == const Color(0xFFF59E0B) || color == Colors.orange) return 'Amber';
  if (color == const Color(0xFFEC4899)) return 'Rose';
  if (color == const Color(0xFF06B6D4)) return 'Cyan';
  if (color == const Color(0xFF64748B)) return 'Slate';
  if (color == const Color(0xFF14B8A6)) return 'Teal';
  if (color == Colors.yellow) return 'Yellow';
  return 'Selected Color';
}

// Color Picker Dialog
class ColorPickerDialog extends StatelessWidget {
  const ColorPickerDialog({super.key});

  static const List<({Color color, String name})> _palette = [
    (color: Color(0xFFEF4444), name: 'Crimson'),
    (color: Color(0xFF10B981), name: 'Emerald'),
    (color: Color(0xFF3B82F6), name: 'Azure'),
    (color: Color(0xFF8B5CF6), name: 'Violet'),
    (color: Color(0xFFF59E0B), name: 'Amber'),
    (color: Color(0xFFEC4899), name: 'Rose'),
    (color: Color(0xFF06B6D4), name: 'Cyan'),
    (color: Color(0xFF64748B), name: 'Slate'),
    (color: Color(0xFF14B8A6), name: 'Teal'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Dialog(
      backgroundColor: cs.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 360),
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: cs.primaryContainer.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.palette_rounded,
                size: 28,
                color: cs.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Select Theme Color',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'Choose an accent color for your interface',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
              ),
              itemCount: _palette.length,
              itemBuilder: (context, index) {
                final item = _palette[index];
                return _ModernColorTile(
                  color: item.color,
                  name: item.name,
                );
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: TextButton(
                onPressed: () => ContextlessUi.closeAllDialogs(),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModernColorTile extends StatelessWidget {
  final Color color;
  final String name;

  const _ModernColorTile({
    required this.color,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => ContextlessUi.closeAllDialogs(color),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withValues(alpha: 0.85),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.35),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Dialog(
      backgroundColor: cs.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: cs.primaryContainer.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.person_add_alt_1_rounded,
                      color: cs.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Account',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Please fill in your information',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Full Name',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'e.g. Alex Morgan',
                  prefixIcon: Icon(Icons.person_outline_rounded, color: cs.primary),
                  filled: true,
                  fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.35),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: cs.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: cs.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: cs.primary, width: 1.8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Email Address',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'e.g. alex@example.com',
                  prefixIcon: Icon(Icons.mail_outline_rounded, color: cs.primary),
                  filled: true,
                  fillColor: cs.surfaceContainerHighest.withValues(alpha: 0.35),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: cs.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: cs.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: cs.primary, width: 1.8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => ContextlessUi.closeAllDialogs(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: cs.outlineVariant),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: cs.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                        label: const Text(
                          'Create',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Dialog(
      backgroundColor: cs.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: cs.errorContainer.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: cs.error.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_forever_rounded,
                    color: cs.error,
                    size: 26,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Delete account across apps?',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Once deleted, you will lose access to the account and saved details across all connected apps.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.45,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  _appBadge(Icons.restaurant_rounded, const Color(0xFFF59E0B)),
                  const SizedBox(width: 8),
                  _appBadge(Icons.shopping_bag_rounded, const Color(0xFF8B5CF6)),
                  const SizedBox(width: 8),
                  _appBadge(Icons.directions_car_rounded, const Color(0xFF0EA5E9)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '3 Connected Apps',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                        Text(
                          'Will be unlinked immediately',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => ContextlessUi.closeAllDialogs(false),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: cs.outlineVariant),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: () => ContextlessUi.closeAllDialogs(true),
                      icon: const Icon(Icons.delete_outline_rounded, size: 18),
                      label: const Text(
                        'Delete',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: cs.error,
                        foregroundColor: cs.onError,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBadge(IconData icon, Color color) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }
}

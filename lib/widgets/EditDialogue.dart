import 'package:flutter/material.dart';
import 'package:modulo/utils/constants/colors.dart';
import 'package:modulo/utils/constants/sizes.dart';

class EditNameDialog extends StatefulWidget {
  const EditNameDialog({
    super.key,
    required this.initialName,
    required this.onSave,
    required this.onCancel,
  });

  final String initialName;
  final Function(String) onSave;
  final VoidCallback onCancel;

  static void show(
    BuildContext context, {
    required String initialName,
    required Function(String) onSave,
    required VoidCallback onCancel,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      builder:
          (context) => EditNameDialog(
            initialName: initialName,
            onSave: onSave,
            onCancel: onCancel,
          ),
    );
  }

  @override
  _EditNameDialogState createState() => _EditNameDialogState();
}

class _EditNameDialogState extends State<EditNameDialog> {
  late TextEditingController _nameController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _focusNode = FocusNode();
    // Auto-focus the TextField when dialog opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = screenWidth * 0.8 - 2 * MySizes.defaultSpace;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: screenWidth * 0.8,
        padding: const EdgeInsets.all(MySizes.defaultSpace),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
          boxShadow: [
            BoxShadow(
              color: MyColors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Edit Name',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: MySizes.spaceBtwItems),
            SizedBox(
              width: buttonWidth,
              child: TextField(
                controller: _nameController,
                focusNode: _focusNode,
                decoration: const InputDecoration(
                  hintText: 'Enter new name',
                  border: OutlineInputBorder(),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: MySizes.spaceBtwItems),
            GestureDetector(
              onTap: () {
                widget.onSave(_nameController.text);
              },
              child: Container(
                width: buttonWidth,
                padding: EdgeInsets.symmetric(
                  vertical: MySizes.defaultSpace / 2,
                  horizontal: MySizes.defaultSpace * 2,
                ),
                decoration: BoxDecoration(
                  color: MyColors.cellColor,
                  borderRadius: BorderRadius.circular(MySizes.borderRadiusLg),
                ),
                child: Center(
                  child: Text(
                    'Save',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge!.copyWith(color: MyColors.white),
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

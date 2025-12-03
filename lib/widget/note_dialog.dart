import 'package:flutter/material.dart';

class NoteDialog extends StatelessWidget {
  final String title;
  final String initialText;
  final String confirmLabel;
  final VoidCallback onCancel;
  final ValueChanged<String> onConfirm;

  const NoteDialog({
    super.key,
    required this.title,
    required this.initialText,
    required this.confirmLabel,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialText);

    return AlertDialog(
      insetPadding: EdgeInsets.all(0.1),
      title: Text(title),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      content: TextField(
        controller: controller,
        minLines: 20,
        maxLines: 100,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Write your note...",
        ),
      ),
      actions: [
        TextButton(onPressed: onCancel, child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () => onConfirm(controller.text.trim()),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}

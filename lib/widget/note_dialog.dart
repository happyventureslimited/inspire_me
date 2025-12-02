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
      title: Text(title),
      content: TextField(
        controller: controller,
        maxLines: 4,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Write your note...",
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => onConfirm(controller.text.trim()),
          child: Text(confirmLabel),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';

Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context, false),
        ),
        ElevatedButton(
          child: const Text("Delete"),
          onPressed: () => Navigator.pop(context, true),
        ),
      ],
    ),
  );

  return result ?? false;
}

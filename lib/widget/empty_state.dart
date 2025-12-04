import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyState({
    super.key,
    required this.message,
    this.icon = Icons.hourglass_empty_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedOpacity(
        opacity: 1,
        duration: const Duration(milliseconds: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 50, color: Colors.grey.shade400),
            const SizedBox(height: 0),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}

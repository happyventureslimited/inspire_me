import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About InspireMe")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "InspireMe",
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 12),

            Text(
              "InspireMe is a personal motivation and reflection app that provides original daily stories across multiple categories including Motivation, Love, Wisdom, Happiness, and more.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 16),

            Text(
              "Features",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 8),

            const Text("• Original inspiring stories"),
            const Text("• Save your favorite stories"),
            const Text("• Add notes to any story"),
            const Text("• Browse stories by category"),
            const Text("• Light and dark themes"),

            const Spacer(),

            Center(
              child: Text(
                "Version 1.0.0",
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

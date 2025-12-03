import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About Inspire Me")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "InspireMe is a personal motivation and reflection app that provides original stories across multiple categories including Motivation, Love, Wisdom, Happiness, and more.",
              style: TextStyle(fontSize: 16, height: 1.3),
            ),

            const Spacer(),

            ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: Text(
                    "Version 1.0.0",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Text(
                    "Developed by Happy Ventures Limited",
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.asset(
                      "assets/images/hv_logo.png",
                      width: 250,
                      // height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: Text(
                    "© 2025 Happy Ventures Limited",
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
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

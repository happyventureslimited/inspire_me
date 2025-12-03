import 'package:flutter/material.dart';
import 'package:inspire_me/data/isar_service.dart';
import 'package:inspire_me/data/seed_service.dart';
import 'package:inspire_me/providers/theme_provider.dart';
import 'package:inspire_me/screens/about.dart';
import 'package:inspire_me/utils/snackbar.dart';
import 'package:provider/provider.dart';
import '../widget/confirm_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  void _navigateTo(BuildContext context, String route) {
    if (route.startsWith('http')) {
      openUrl(context, route);
    } else {
      Navigator.pop(context);
      Navigator.pushNamed(context, route);
    }
  }

  Future<void> openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      }
    } catch (e) {
      try {
        await launchUrl(uri, mode: LaunchMode.inAppWebView);
      } catch (e2) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Could not open link: $e2")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isarService = context.read<IsarService>();
    final seedService = SeedService(isarService);

    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                leading: const Icon(Icons.info_outline),
                title: const Text("About"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutScreen()),
                  );
                },
              ),
            ),
            SizedBox(height: 12),
            Card(
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text("Privacy Policy"),
                onTap: () => _navigateTo(
                  context,
                  'https://inspireme.happyventureslimited.com/privacy-policy',
                ),
              ),
            ),
            const SizedBox(height: 50),
            SwitchListTile(
              title: const Text("Dark Mode"),
              value: context.watch<ThemeProvider>().isDark,
              onChanged: (value) {
                context.read<ThemeProvider>().setTheme(
                  value ? ThemeMode.dark : ThemeMode.light,
                );
              },
              thumbIcon: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const Icon(Icons.dark_mode, size: 16);
                }
                return const Icon(Icons.light_mode, size: 16);
              }),
              activeTrackColor: Theme.of(context).colorScheme.tertiary,
              inactiveTrackColor: Theme.of(context).colorScheme.tertiary,
              activeThumbColor: Theme.of(context).colorScheme.primary,
              inactiveThumbColor: Theme.of(context).colorScheme.primary,
            ),
            const Divider(height: 28, thickness: .3),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Reset App",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh_outlined),
                    color: Colors.red,
                    iconSize: 30,
                    onPressed: () async {
                      final yes = await showConfirmDialog(
                        context: context,
                        title: "Reset App?",
                        message:
                            "This will reset the app and delete all saved stories and notes. Continue?",
                      );

                      if (yes) {
                        await seedService.clearDatabase();
                        await seedService.seedStoriesIfNeeded();

                        context.read<ThemeProvider>().setTheme(ThemeMode.light);

                        // ignore: use_build_context_synchronously
                        AppSnack.show(context, "App reset complete");
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

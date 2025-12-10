import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:inspire_me/data/db_service.dart'; 
import 'package:inspire_me/data/seed_service.dart'; 
import 'package:inspire_me/providers/theme_provider.dart';
import 'package:inspire_me/screens/about.dart';
import 'package:inspire_me/utils/snackbar.dart';
import '../widget/confirm_dialog.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
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
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not open link: $e2")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dbService = context.read<DBService>();
    final seedService = SeedService(dbService.db);
    
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          child: ListView(
            children: [
              Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
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
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
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
                title: Text(context.watch<ThemeProvider>().isDark ? "Dark Mode" : "Light Mode"),
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
                          title: "Reset App!",
                          message:
                              "Are you sure?\nThis will reset the app and delete all saved stories and notes.",
                          confirmbtn: "Continue",
                        );

                        if (!yes) return;

                        try {
                          await seedService.clearDatabase();
                          await seedService.seedStoriesIfNeeded();

                          if (!mounted) return;
                          context.read<ThemeProvider>().setTheme(ThemeMode.light);
                          if (!mounted) return;
                          AppSnack.show(context, "App reset complete");
                        } catch (e) {
                          if (!mounted) return;
                          AppSnack.show(context, "Failed to reset app: $e");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:inspire_me/data/isar_service.dart';
import 'package:inspire_me/data/seed_service.dart';
import 'package:inspire_me/providers/theme_provider.dart';
import 'package:inspire_me/screens/about.dart';
import 'package:inspire_me/utils/snackbar.dart';
import 'package:provider/provider.dart';
// import '../../providers/story_provider.dart';
import '../widget/confirm_dialog.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final sp = context.read<StoryProvider>();
    final isarService = context.read<IsarService>();
    final seedService = SeedService(isarService);

    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(padding: const EdgeInsets.all(0), children: [
        SwitchListTile(
          title: const Text("Dark Mode"),
          value: context.watch<ThemeProvider>().isDark,
          onChanged: (value) {
            context.read<ThemeProvider>().setTheme(
              value ? ThemeMode.dark : ThemeMode.light,
            );
          },
        ),
        const Divider(height: 28),
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
                        "This action will delete all notes and saved stories!",
                  );

                  if (yes) {
                    // Correct: Use existing Isar instance via Provider
                    await seedService.clearDatabase();
                    await seedService.seedStoriesIfNeeded();

                    // ignore: use_build_context_synchronously
                    AppSnack.show(context, "App reset complete");
                  }
                },
              ),
            ],
          ),
        ),
        // IconButton(
        //   icon: const Icon(Icons.delete, color: Colors.red),
        //   onPressed: () async {
        //     final yes = await showConfirmDialog(
        //       context: context,
        //       title: "Delete Note?",
        //       message: "Are you sure you want to delete this note?",
        //     );

        //     // if (yes) {
        //     //   np.deleteNote(n.id);
        //     //   // ignore: use_build_context_synchronously
        //     //   AppSnack.show(context, "Note deleted");
        //     // }
        //   },
        // ),
        const SizedBox(height: 60),
        Card(child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
        SizedBox(height: 12,),
        Card(child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text("Privacy Policy"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutScreen()),
              );
            },
          ),
        ),
      ]),
    );
  }
}


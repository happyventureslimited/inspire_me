import 'package:flutter/material.dart';
import 'package:inspire_me/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'navigation/main_scaffold.dart';
import 'data/isar_service.dart';
import 'data/seed_service.dart';
import 'providers/story_provider.dart';
import 'providers/notes_provider.dart';
import 'providers/theme_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isarService = IsarService();
  await isarService.init();

  final seeder = SeedService(isarService);
  await seeder.seedStoriesIfNeeded();

  runApp(InspireMe(isarService: isarService));
}


class InspireMe extends StatelessWidget {
  final IsarService isarService;
  const InspireMe({super.key, required this.isarService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<IsarService>.value(value: isarService),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => StoryProvider(isarService)),
        ChangeNotifierProvider(create: (_) => NotesProvider(isarService)),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: "Inspire Me",
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.mode,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            home: const MainScaffold(),
          );
        },
      ),
    );
  }
}

// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'navigation/main_scaffold.dart';

import 'data/database.dart';      // AppDatabase (Drift)
import 'data/db_service.dart';    // DBService (wrapper that holds AppDatabase)
import 'data/seed_service.dart';  // SeedService (uses DBService)
import 'providers/theme_provider.dart';
import 'providers/story_provider.dart';
import 'providers/notes_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Drift DB service
  final dbService = DBService();
  await dbService.init();

  // Seed offline stories (if not present)
  final seeder = SeedService(dbService.db);
  await seeder.seedStoriesIfNeeded();

  // Grab the raw AppDatabase for providers that expect it
  final appDb = dbService.db;

  runApp(InspireMe(dbService: dbService, appDb: appDb));
}

class InspireMe extends StatelessWidget {
  final DBService dbService;
  final AppDatabase appDb;

  const InspireMe({
    super.key,
    required this.dbService,
    required this.appDb,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide both the DBService (for screens that call higher-level helpers)
        // and the raw AppDatabase (for providers that operate directly on Drift).
        Provider<DBService>.value(value: dbService),
        Provider<AppDatabase>.value(value: appDb),

        // App state providers
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        // StoryProvider & NotesProvider were converted to accept AppDatabase
        // (if yours accept DBService instead, replace `appDb` with `dbService`)
        ChangeNotifierProvider(create: (_) => StoryProvider(appDb)),
        ChangeNotifierProvider(create: (_) => NotesProvider(appDb)),
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

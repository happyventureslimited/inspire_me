import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme/app_theme.dart';
import 'navigation/main_scaffold.dart';

import 'data/database.dart';      
import 'data/db_service.dart'; 
import 'data/seed_service.dart'; 
import 'providers/theme_provider.dart';
import 'providers/story_provider.dart';
import 'providers/notes_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbService = DBService();
  await dbService.init();

  final seeder = SeedService(dbService.db);
  await seeder.seedStoriesIfNeeded();

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
        Provider<DBService>.value(value: dbService),
        Provider<AppDatabase>.value(value: appDb),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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

import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import '../data/database.dart'; 

class StoryProvider extends ChangeNotifier {
  final AppDatabase db;
  StoryProvider(this.db);

  List<String> categories = [];
  List<Story> stories = [];
  List<Story> saved = [];

  bool _isLoaded = false;

  Future<void> preloadStories(List<StoriesCompanion> initialStories) async {
    if (_isLoaded) return;

    if (initialStories.isNotEmpty) {
      await db.batch((b) {
        b.insertAllOnConflictUpdate(db.stories, initialStories);
      });
    }

    _isLoaded = true;
  }

  Future<void> loadCategories() async {
    final all = await db.select(db.stories).get();
    categories = all.map((s) => s.category).toSet().toList();
    categories.sort();
    notifyListeners();
  }

  Future<void> loadStoriesByCategory(String category) async {
    final query = db.select(db.stories)
      ..where((t) => t.category.equals(category))
      ..orderBy([(t) => OrderingTerm(expression: t.title)]);
    stories = await query.get();
    notifyListeners();
  }

  Future<void> loadSaved() async {
    final query = db.select(db.stories)
      ..where((t) => t.isSaved.equals(true))
      ..orderBy([
        (t) => OrderingTerm(expression: t.savedAt, mode: OrderingMode.desc),
      ]);
    saved = await query.get();
    notifyListeners();
  }

  Future<Story?> getStoryById(int id) async {
    return await (db.select(db.stories)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> toggleSaved(Story story) async {
    final newSaved = !story.isSaved;
    final newSavedAt = newSaved ? DateTime.now() : null;

    await (db.update(db.stories)..where((t) => t.id.equals(story.id))).write(
      StoriesCompanion(
        isSaved: Value(newSaved),
        savedAt: Value(newSavedAt),
      ),
    );

    await loadSaved();
    notifyListeners();
  }

  bool isStorySaved(Story s) => s.isSaved;

  List<Story> paginate(List<Story> source, int page, int pageSize) {
    final start = page * pageSize;
    if (start >= source.length) return [];

    final end = (start + pageSize).clamp(0, source.length);
    return source.sublist(start, end);
  }
}

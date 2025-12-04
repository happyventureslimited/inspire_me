import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../data/isar_service.dart';
import '../models/story.dart';

class StoryProvider extends ChangeNotifier {
  final IsarService isar;
  StoryProvider(this.isar);

  // ---------------------------------------------------------
  // STATE
  // ---------------------------------------------------------
  List<String> categories = [];
  List<Story> stories = [];
  List<Story> saved = [];

  bool _isLoaded = false;

  // ---------------------------------------------------------
  // INITIAL LOAD (OPTIONAL PRELOAD)
  // ---------------------------------------------------------
  Future<void> preloadStories(List<Story> initialStories) async {
    if (_isLoaded) return;

    await isar.isar.writeTxn(() async {
      await isar.isar.storys.putAll(initialStories);
    });

    _isLoaded = true;
  }

  // ---------------------------------------------------------
  // CATEGORIES
  // ---------------------------------------------------------
  Future<void> loadCategories() async {
    final all = await isar.isar.storys.where().findAll();
    categories = all.map((s) => s.category).toSet().toList();
    categories.sort();
    notifyListeners();
  }

  // ---------------------------------------------------------
  // STORIES BY CATEGORY
  // ---------------------------------------------------------
  Future<void> loadStoriesByCategory(String category) async {
    stories = await isar.isar.storys
        .filter()
        .categoryEqualTo(category)
        .sortByTitle()
        .findAll();

    notifyListeners();
  }

  // ---------------------------------------------------------
  // SAVED
  // ---------------------------------------------------------
  Future<void> loadSaved() async {
    saved = await isar.isar.storys
        .filter()
        .isSavedEqualTo(true)
        .sortByTitle()
        .findAll();

    notifyListeners();
  }

  Future<void> toggleSaved(Story story) async {
    await isar.isar.writeTxn(() async {
      story.isSaved = !story.isSaved;
      await isar.isar.storys.put(story);
    });

    await loadSaved();
    notifyListeners();
  }

  bool isStorySaved(Story s) => s.isSaved == true;

  // ---------------------------------------------------------
  // SEARCH
  // ---------------------------------------------------------
  Future<List<Story>> search(String query) async {
    if (query.trim().isEmpty) return stories;

    final q = query.toLowerCase();

    return stories.where((s) =>
        s.title.toLowerCase().contains(q) ||
        s.content.toLowerCase().contains(q) ||
        s.lesson.toLowerCase().contains(q) 
    ).toList();
  }

  // ---------------------------------------------------------
  // PAGINATION (LOCAL)
  // ---------------------------------------------------------
  List<Story> paginate(List<Story> source, int page, int pageSize) {
    final start = page * pageSize;
    final end = start + pageSize;

    if (start >= source.length) return [];

    return source.sublist(start, end.clamp(0, source.length));
  }

  // ---------------------------------------------------------
  // CLEAR ALL (More Screen)
  // ---------------------------------------------------------
  Future<void> clearSavedFlags() async {
    final all = await isar.isar.storys.where().findAll();

    await isar.isar.writeTxn(() async {
      for (final s in all) {
        s.isSaved = false;
      }
      await isar.isar.storys.putAll(all);
    });

    saved.clear();
    notifyListeners();
  }
}

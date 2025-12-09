import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../data/isar_service.dart';
import '../models/story.dart';

class StoryProvider extends ChangeNotifier {
  final IsarService isar;
  StoryProvider(this.isar);

  List<String> categories = [];
  List<Story> stories = [];
  List<Story> saved = [];

  bool _isLoaded = false;

  Future<void> preloadStories(List<Story> initialStories) async {
    if (_isLoaded) return;

    await isar.isar.writeTxn(() async {
      await isar.isar.storys.putAll(initialStories);
    });

    _isLoaded = true;
  }

  Future<void> loadCategories() async {
    final all = await isar.isar.storys.where().findAll();
    categories = all.map((s) => s.category).toSet().toList();
    categories.sort();
    notifyListeners();
  }

  Future<void> loadStoriesByCategory(String category) async {
    stories = await isar.isar.storys
        .filter()
        .categoryEqualTo(category)
        .sortByTitle()
        .findAll();

    notifyListeners();
  }

  Future<void> loadSaved() async {
    saved = await isar.isar.storys
        .filter()
        .isSavedEqualTo(true)
        .sortBySavedAtDesc()
        .findAll();

    notifyListeners();
  }

  Future<void> toggleSaved(Story story) async {
    await isar.isar.writeTxn(() async {
      story.isSaved = !story.isSaved;
      if (story.isSaved) {
        story.savedAt = DateTime.now();
      } else {
        story.savedAt = null;
      }
      await isar.isar.storys.put(story);
    });

    await loadSaved();
    notifyListeners();
  }

  bool isStorySaved(Story s) => s.isSaved == true;

  List<Story> paginate(List<Story> source, int page, int pageSize) {
    final start = page * pageSize;
    final end = start + pageSize;

    if (start >= source.length) return [];

    return source.sublist(start, end.clamp(0, source.length));
  }
}
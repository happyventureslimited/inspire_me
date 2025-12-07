import 'package:flutter/foundation.dart';
import 'package:isar_plus/isar_plus.dart';
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

    await isar.isar.writeAsync((isar) async{
      isar.storys.clear(); 
      isar.storys.putAll(initialStories);
    });

    _isLoaded = true;
  }

  Future<void> loadCategories() async {
    final all = isar.isar.storys.where().findAll();
    categories = all.map((s) => s.category).toSet().toList();
    categories.sort();
    notifyListeners();
  }

  Future<void> loadStoriesByCategory(String category) async {
    stories = isar.isar.storys
        .where()
        .categoryEqualTo(category)
        .sortByTitle()
        .findAll();
    notifyListeners();
  }

  Future<void> loadSaved() async {
    saved = isar.isar.storys
        .where()
        .isSavedEqualTo(true)
        .sortByTitle()
        .findAll();
    notifyListeners();
  }

  Future<void> toggleSaved(Story story) async {
    await isar.isar.writeAsync((isar) {
      story.isSaved = !story.isSaved;
      isar.storys.put(story);
    });

    await loadSaved();
    await loadStoriesByCategory(story.category);
    notifyListeners();
  }

  bool isStorySaved(Story s) => s.isSaved == true;
}

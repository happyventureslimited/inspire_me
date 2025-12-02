import 'package:inspire_me/models/note.dart';
import 'package:inspire_me/models/story.dart';
import 'isar_service.dart';
import './stories.dart';

class SeedService {
  final IsarService isar;
  SeedService(this.isar);

  Future<void> seedStoriesIfNeeded() async {
    final count = await isar.isar.storys.count();
    if (count > 0) return;

    await isar.isar.writeTxn(() async {
      await isar.isar.storys.putAll(offlineStories);
    });
  }

  /// Clear EVERYTHING in the database (stories, notes, etc.)
  Future<void> clearDatabase() async {
    await isar.isar.writeTxn(() async {
      await isar.isar.clear();
    });
  }

  /// Only clear stories
  Future<void> clearStories() async {
    await isar.isar.writeTxn(() async {
      await isar.isar.storys.clear();
    });
  }

  /// Only clear notes
  Future<void> clearNotes() async {
    await isar.isar.writeTxn(() async {
      await isar.isar.notes.clear();
    });
  }
}

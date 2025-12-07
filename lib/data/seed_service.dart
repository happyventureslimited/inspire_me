import 'package:inspire_me/models/story.dart';
import 'isar_service.dart';
import './stories.dart';
// import 'package:inspire_me/models/note.dart';

class SeedService {
  final IsarService isar;
  SeedService(this.isar);

  Future<void> seedStoriesIfNeeded() async {
    final count = isar.isar.storys.count();
    if (count > 0) return;

    await isar.isar.writeAsync((isar) {
      isar.storys.putAll(offlineStories);
    });
  }

  Future<void> clearDatabase() async {
    await isar.isar.writeAsync((isar) {
      isar.clear();
    });
  }

  // Future<void> clearStories() async {
  //   await isar.isar.writeAsync((isar) async {
  //     isar.storys.clear();
  //   });
  // }

  // Future<void> clearNotes() async {
  //   await isar.isar.writeAsync((isar) async {
  //     isar.notes.clear();
  //   });
  // }
}

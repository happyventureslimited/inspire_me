import './database.dart';
import './stories.dart';

class SeedService {
  final AppDatabase db;
  SeedService(this.db);

  Future<void> seedStoriesIfNeeded() async {
    final count = await db.select(db.stories).get().then((rows) => rows.length);

    if (count > 0) return;

    await db.batch((batch) {
      batch.insertAll(db.stories, offlineStories);
    });
  }

  Future<void> clearDatabase() async {
    await db.delete(db.stories).go();
    await db.delete(db.notes).go();
  }
}

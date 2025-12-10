import 'package:drift/drift.dart';
import 'database.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  factory DBService() => _instance;
  DBService._internal();

  late AppDatabase db;

  Future<void> init() async {
    db = AppDatabase();
    // Optionally run migrations or seed checks here.
  }

  // Story helpers (equivalent to your isar usage)
  Future<List<Story>> getAllStories() => db.getAllStories();

  Future<int> countStories() async {
    // more efficient count using SQL
    final result = await db.customSelect('SELECT COUNT(*) as c FROM stories').getSingle();
    return result.data['c'] as int;
  }

  Future<void> putStory({
    int? id,
    required String category,
    required String title,
    required String content,
    required String lesson,
    bool isSaved = false,
    DateTime? savedAt,
  }) async {
    final companion = StoriesCompanion(
      id: id == null ? const Value.absent() : Value(id),
      category: Value(category),
      title: Value(title),
      content: Value(content),
      lesson: Value(lesson),
      isSaved: Value(isSaved),
      savedAt: Value(savedAt),
    );
    await db.into(db.stories).insertOnConflictUpdate(companion);
  }

  Future<void> putAllStories(List<Map<String, dynamic>> items) async {
    // Accepts a list of maps (like your offlineStories). Converts and inserts in a single transaction.
    await db.transaction(() async {
      final batch = <StoriesCompanion>[];
      for (final m in items) {
        batch.add(StoriesCompanion.insert(
          // if offlineStories have an id field, you can use Value(m['id']) and a non-autoIncrement insert
          category: m['category'] as String,
          title: m['title'] as String,
          content: m['content'] as String,
          lesson: m['lesson'] as String? ?? '',
          isSaved: Value(m['isSaved'] as bool? ?? false),
          savedAt: Value(m['savedAt'] != null ? DateTime.parse(m['savedAt'].toString()) : null),
        ));
      }
      if (batch.isNotEmpty) {
        for (final c in batch) {
          await db.into(db.stories).insertOnConflictUpdate(c);
        }
      }
    });
  }

  Future<void> clearDatabase() async {
    await db.transaction(() async {
      await db.delete(db.stories).go();
      await db.delete(db.notes).go();
    });
  }

  // Notes helpers
  Future<List<Note>> getAllNotes() => db.select(db.notes).get();

  Future<void> putNote({
    int? id,
    required String content,
    required DateTime createdAt,
  }) async {
    final companion = NotesCompanion(
      id: id == null ? const Value.absent() : Value(id),
      content: Value(content),
      createdAt: Value(createdAt),
    );
    await db.into(db.notes).insertOnConflictUpdate(companion);
  }
}

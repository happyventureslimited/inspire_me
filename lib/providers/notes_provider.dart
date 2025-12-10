import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import '../data/database.dart'; // AppDatabase, Note, NotesCompanion

class NotesProvider extends ChangeNotifier {
  final AppDatabase db;
  NotesProvider(this.db);

  List<Note> notes = [];

  Future<void> loadAllNotes() async {
    // Order by createdAt DESC
    final query = db.select(db.notes)
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    notes = await query.get();
    notifyListeners();
  }

  Future<int> createNote({required String content}) async {
    final now = DateTime.now();
    final companion = NotesCompanion.insert(
      content: content,
      createdAt: now,
    );

    final id = await db.into(db.notes).insert(companion);
    await loadAllNotes();
    return id;
  }

  Future<void> updateNote(Note note, String newContent) async {
    // Use typed update
    await (db.update(db.notes)
          ..where((tbl) => tbl.id.equals(note.id)))
        .write(
      NotesCompanion(
        content: Value(newContent),
        // keep createdAt unchanged — only update content
      ),
    );

    await loadAllNotes();
  }

  Future<void> deleteNote(int noteId) async {
    await (db.delete(db.notes)..where((tbl) => tbl.id.equals(noteId))).go();
    await loadAllNotes();
  }
}

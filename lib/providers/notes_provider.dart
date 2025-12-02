import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../data/isar_service.dart';
import '../models/note.dart';

class NotesProvider extends ChangeNotifier {
  final IsarService isar;
  NotesProvider(this.isar);

  List<Note> notes = [];

  // LOAD ALL NOTES
  Future<void> loadAllNotes() async {
    notes = await isar.isar.notes.where().sortByCreatedAtDesc().findAll();
    notifyListeners();
  }

  // LOAD NOTES FOR ONE STORY
  Future<void> loadNotesForStory(int storyId) async {
    notes = await isar.isar.notes
        .filter()
        .storyIdEqualTo(storyId)
        .sortByCreatedAtDesc()
        .findAll();
    notifyListeners();
  }

  // CREATE NOTE
  Future<void> createNote({required int storyId, required String content}) async {
    final note = Note()
      ..storyId = storyId
      ..content = content
      ..createdAt = DateTime.now();

    await isar.isar.writeTxn(() async {
      await isar.isar.notes.put(note);
    });

    await loadAllNotes();
  }

  // UPDATE NOTE
  Future<void> updateNote(Note note, String newContent) async {
    note.content = newContent;

    await isar.isar.writeTxn(() async {
      await isar.isar.notes.put(note);
    });

    await loadAllNotes();
  }

  // DELETE NOTE
  Future<void> deleteNote(int noteId) async {
    await isar.isar.writeTxn(() async {
      await isar.isar.notes.delete(noteId);
    });

    await loadAllNotes();
  }
}

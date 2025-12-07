import 'package:flutter/material.dart';
import 'package:isar_plus/isar_plus.dart';
import '../data/isar_service.dart';
import '../models/note.dart';

class NotesProvider extends ChangeNotifier {
  final IsarService isar;
  NotesProvider(this.isar);

  List<Note> notes = [];

  Future<void> loadAllNotes() async {
    notes = isar.isar.notes.where().sortByCreatedAtDesc().findAll();
    notifyListeners();
  }

  Future<void> createNote({required String content}) async {
    final note = Note()
      ..content = content
      ..createdAt = DateTime.now();

    await isar.isar.writeAsync((isar) {
      isar.notes.put(note);
    });

    await loadAllNotes();
  }

  Future<void> updateNote(Note note, String newContent) async {
    note.content = newContent;

    await isar.isar.writeAsync((isar) {
      isar.notes.put(note);
    });

    await loadAllNotes();
  }

  Future<void> deleteNote(int noteId) async {
    await isar.isar.writeAsync((isar) {
      isar.notes.delete(noteId);
    });

    await loadAllNotes();
  }
}

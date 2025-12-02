import 'package:flutter/material.dart';
import 'package:inspire_me/utils/snackbar.dart';
import 'package:inspire_me/widget/empty_state.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/notes_provider.dart';
import '../widget/note_dialog.dart';
import '../widget/confirm_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await context.read<NotesProvider>().loadAllNotes();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final np = context.watch<NotesProvider>();
    final notes = np.notes;

    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.note_add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => NoteDialog(
              title: "Add Note",
              initialText: "",
              confirmLabel: "Save",
              onCancel: () => Navigator.pop(context),
              onConfirm: (text) {
                if (text.isNotEmpty) {
                  np.createNote(
                    storyId: 0,
                    content: text,
                  ); // storyId 0 = general note
                }
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
          ? const EmptyState(message: 'No notes available')
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: notes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final n = notes[i];
                final formatted = DateFormat('yyyy-MM-dd    hh:mm a').format(n.createdAt.toLocal());

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      n.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(formatted),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => NoteDialog(
                          title: "Edit Note",
                          initialText: n.content,
                          confirmLabel: "Update",
                          onCancel: () => Navigator.pop(context),
                          onConfirm: (text) {
                            if (text.isNotEmpty) {
                              np.updateNote(n, text);
                            }
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final yes = await showConfirmDialog(
                          context: context,
                          title: "Delete Note?",
                          message: "Are you sure you want to delete this note?",
                        );

                        if (yes) {
                          np.deleteNote(n.id);
                          // ignore: use_build_context_synchronously
                          AppSnack.show(context, "Note deleted");
                        }
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

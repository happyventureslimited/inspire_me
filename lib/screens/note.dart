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
                  np.createNote(content: text);
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
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              itemCount: notes.length,
              itemBuilder: (context, i) {
                final n = notes[i];
                final formatted = DateFormat(
                  'yyyy-MM-dd    hh:mm a',
                ).format(n.createdAt.toLocal());

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 12, top: 5, right: 5, bottom: 5),
                    horizontalTitleGap: 2,
                    title: Text(
                      n.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(height: 1.2),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          formatted,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
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
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 30,
                        height: 30,
                      ),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () async {
                        final yes = await showConfirmDialog(
                          context: context,
                          title: "Delete Note!",
                          message:
                              "Are you sure?\nThis will permanently delete the note.",
                          confirmbtn: "Delete"
                        );
                        if (yes) {
                          np.deleteNote(n.id);
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
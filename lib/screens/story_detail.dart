import 'package:flutter/material.dart';
import 'package:inspire_me/utils/snackbar.dart';
import 'package:inspire_me/widget/note_dialog.dart';
import 'package:provider/provider.dart';
import '../../providers/story_provider.dart';
import '../../providers/notes_provider.dart';

class StoryDetailScreen extends StatelessWidget {
  final int storyId;

  const StoryDetailScreen({super.key, required this.storyId});

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<StoryProvider>();
    // final np = context.watch<NotesProvider>();

    final story = sp.stories.firstWhere(
      (s) => s.id == storyId,
      orElse: () => sp.saved.firstWhere((s) => s.id == storyId),
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(story.isSaved ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () {
              sp.toggleSaved(story);
              if (!story.isSaved) {
                AppSnack.show(context, "Story saved!");
              } else {
                AppSnack.show(context, "Story removed from saved");
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.note_add),
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
                        context.read<NotesProvider>().createNote(
                          storyId: storyId,
                          content: text,
                        );
                      }
                      Navigator.pop(context);
                      AppSnack.show(context, "Note added successfully!");
                    },
                  ),
                );
              },
          )
          
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Text(story.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),

            /// CONTENT (scrollable)
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  story.content,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// PUNCHLINE
            Text('Punchline:', style: Theme.of(context).textTheme.titleMedium),
            Text(
              story.punchline,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

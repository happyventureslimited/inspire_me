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
            padding: EdgeInsets.symmetric(horizontal: 17),
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
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 30),
        child: Column(
          children: [
            Text(
              story.title,
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20, 
                fontWeight: FontWeight.w600
                ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: SingleChildScrollView(
                child: Text(story.content, style: TextStyle(fontSize: 16.7, height: 1.4)),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Punchline:',
              textAlign: TextAlign.justify,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 5,),
            Text(
              story.punchline,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      ),
    );
  }
}

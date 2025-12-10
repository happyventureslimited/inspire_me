import 'package:flutter/material.dart';
import 'package:inspire_me/utils/snackbar.dart';
import 'package:inspire_me/widget/empty_state.dart';
import 'package:inspire_me/widget/note_dialog.dart';
import 'package:provider/provider.dart';

import '../../data/database.dart';          // <-- IMPORTANT FIX
import '../../providers/story_provider.dart';
import '../../providers/notes_provider.dart';

class StoryDetailScreen extends StatefulWidget {
  final int storyId;
  final bool fromSaved;

  const StoryDetailScreen({
    super.key,
    required this.storyId,
    required this.fromSaved,
  });

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  Story? story;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadStory();
  }

  Future<void> loadStory() async {
    final sp = context.read<StoryProvider>();

    final s = await sp.getStoryById(widget.storyId); // <-- FIXED
    setState(() {
      story = s;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<StoryProvider>();

    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (story == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(message: 'Story not found'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [

          /// SAVE / UNSAVE
          IconButton(
            icon: Icon(
              story!.isSaved ? Icons.bookmark : Icons.bookmark_border,
            ),
            onPressed: () async {
              await sp.toggleSaved(story!);

              setState(() {});

              if (!story!.isSaved) {
                AppSnack.show(context, "Removed from saved");
                if (widget.fromSaved) Navigator.pop(context);
              } else {
                AppSnack.show(context, "Story saved!");
              }
            },
          ),

          /// ADD NOTE
          IconButton(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            icon: const Icon(Icons.note_add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => NoteDialog(
                  title: "Add Note",
                  initialText: "",
                  confirmLabel: "Save",
                  onCancel: () => Navigator.pop(context),
                  onConfirm: (text) async {
                    if (text.isNotEmpty) {
                      await context.read<NotesProvider>().createNote(content: text);
                    }
                    Navigator.pop(context);
                    AppSnack.show(context, "Note created!");
                  },
                ),
              );
            },
          ),
        ],
      ),

      /// BODY
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 30),
        child: ListView(
          children: [

            Text(
              story!.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              story!.content,
              style: const TextStyle(fontSize: 16.7, height: 1.4),
            ),

            const SizedBox(height: 50),

            Text(
              'Lesson:',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              story!.lesson,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

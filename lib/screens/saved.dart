import 'package:flutter/material.dart';
import 'package:inspire_me/providers/story_provider.dart';
import 'package:inspire_me/screens/story_detail.dart';
import 'package:provider/provider.dart';
import '../widget/empty_state.dart';
import '../../utils/snackbar.dart'; 

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await context.read<StoryProvider>().loadSaved();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<StoryProvider>();
    final saved = sp.saved;

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Stories')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : saved.isEmpty
              ? const EmptyState(message: 'No saved stories')
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  itemCount: saved.length,
                  itemBuilder: (context, i) {
                  final story = saved[i];

                    return Card(
                      elevation: 2,
                      shadowColor: Theme.of(context).colorScheme.onTertiaryFixed,
                      color: Theme.of(context).colorScheme.tertiary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StoryDetailScreen(storyId: story.id, fromSaved: true),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                height: 48,
                                width: 48,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.auto_stories,
                                  color: Theme.of(context).colorScheme.tertiary,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(width: 16),
                    
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      story.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 4),
                    
                                    Text(
                                      story.content,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                    
                              IconButton(
                                icon: Icon(Icons.bookmark, color: Theme.of(context).colorScheme.primary,),
                                onPressed: () {
                                  sp.toggleSaved(story);

                                  if (!story.isSaved) {
                                    AppSnack.show(context, "Story saved!");
                                  } else {
                                    AppSnack.show(context, "Removed from saved");
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:inspire_me/screens/story_detail.dart';
import 'package:provider/provider.dart';
import '../../providers/story_provider.dart';

class StoryListScreen extends StatefulWidget {
  final String category;
  const StoryListScreen({super.key, required this.category});

  @override
  State<StoryListScreen> createState() => _StoryListScreenState();
}

class _StoryListScreenState extends State<StoryListScreen> {
  @override
  void initState() {
    super.initState();
    // ignore: use_build_context_synchronously
    Future.microtask(() => context.read<StoryProvider>().loadStoriesByCategory(widget.category));
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<StoryProvider>();
    final stories = sp.stories;

    return Scaffold(
      appBar: AppBar(title: Text('${widget.category} Stories')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        itemCount: stories.length,
        itemBuilder: (context, index) {
        final story = stories[index];

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
                  builder: (_) => StoryDetailScreen(storyId: story.id, fromSaved: false),
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
        
                  Icon(
                    Icons.chevron_right_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        );
        }
      ),
    );
  }
}
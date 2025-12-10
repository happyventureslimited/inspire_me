import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/category_card.dart';
import '../widget/category_icons.dart';
import '../../providers/story_provider.dart';
import './story_list.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    // ignore: use_build_context_synchronously
    Future.microtask(() => context.read<StoryProvider>().loadCategories());
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<StoryProvider>();
    final categories = sp.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 35),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            return CategoryCard(
              title: cat,
              icon: CategoryIcons.forCategory(cat),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => StoryListScreen(category: cat)),
              ),
            );
          },
        ),
      ),
    );
  }
}

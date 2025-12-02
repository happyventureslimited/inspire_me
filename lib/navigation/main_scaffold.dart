import 'package:flutter/material.dart';
import '../screens/categories.dart';
import '../screens/saved.dart';
import '../screens/note.dart';
import '../screens/more.dart';
// import '../screens/story_list_screen.dart';
// import '../screens/story_detail_screen.dart';

class MainScaffold extends StatefulWidget {
  final int initialIndex;
  final Widget? child;

  const MainScaffold({
    super.key,
    this.initialIndex = 0,
    this.child,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  Widget _pageFromIndex() {
    switch (_index) {
      case 0:
        return const CategoriesScreen();
      case 1:
        return const SavedScreen();
      case 2:
        return const NotesScreen();
      case 3:
        return const MoreScreen();
      default:
        return const CategoriesScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget page = widget.child ?? _pageFromIndex();

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: page,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) {
          setState(() => _index = i);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Categories'),
          NavigationDestination(icon: Icon(Icons.bookmark), label: 'Saved'),
          NavigationDestination(icon: Icon(Icons.note), label: 'Notes'),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: 'More'),
        ],
      ),
    );
  }
}

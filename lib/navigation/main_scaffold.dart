import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/categories.dart';
import '../screens/saved.dart';
import '../screens/note.dart';
import '../screens/more.dart';
import '../providers/story_provider.dart';

class MainScaffold extends StatefulWidget {
  final int initialIndex;
  final Widget? child;
  const MainScaffold({super.key, this.initialIndex = 0, this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _index;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final storyProvider = context.read<StoryProvider>();
      await storyProvider.loadCategories();
      await storyProvider.loadSaved();
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
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
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    final Widget page = widget.child ?? _pageFromIndex();
    
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 1000),
        child: page,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: NavigationBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            height: 70,
            labelPadding: EdgeInsets.all(0),
            indicatorColor: Theme.of(context).colorScheme.secondary,
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSecondary,
                );
              }
              return TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.onSecondary,
              );
            }),
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.list, color: Theme.of(context).colorScheme.onSecondary),
                label: 'Categories',
              ),
              NavigationDestination(
                icon: Icon(Icons.bookmark, color: Theme.of(context).colorScheme.onSecondary),
                label: 'Saved',
              ),
              NavigationDestination(
                icon: Icon(Icons.note, color: Theme.of(context).colorScheme.onSecondary),
                label: 'Notes',
              ),
              NavigationDestination(
                icon: Icon(Icons.more_horiz, color: Theme.of(context).colorScheme.onSecondary),
                label: 'More',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
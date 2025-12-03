import 'package:flutter/material.dart';
import '../screens/categories.dart';
import '../screens/saved.dart';
import '../screens/note.dart';
import '../screens/more.dart';

class MainScaffold extends StatefulWidget {
  final int initialIndex;
  final Widget? child;

  const MainScaffold({super.key, this.initialIndex = 0, this.child});

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
                return const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFF5F5F5),
                );
              }
              return const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFFF5F5F5),
              );
            }),
            selectedIndex: _index,
            onDestinationSelected: (i) => setState(() => _index = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.list, color: Color(0xFFF5F5F5)), label: 'Categories',),
              NavigationDestination(icon: Icon(Icons.bookmark, color: Color(0xFFF5F5F5)), label: 'Saved'),
              NavigationDestination(icon: Icon(Icons.note, color: Color(0xFFF5F5F5)), label: 'Notes'),
              NavigationDestination(icon: Icon(Icons.more_horiz, color: Color(0xFFF5F5F5)), label: 'More',),
            ],
          ),
        ),
      ),
    );
  }
}

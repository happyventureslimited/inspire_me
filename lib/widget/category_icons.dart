import 'package:flutter/material.dart';

class CategoryIcons {
  static final Map<String, IconData> map = {
    "Motivational": Icons.flash_on,
    "Success": Icons.emoji_events,
    "Life": Icons.self_improvement,
    "Love": Icons.favorite,
    "Wisdom": Icons.menu_book,
    "Happiness": Icons.sentiment_satisfied,
    "Spiritual": Icons.light_mode,
    "Friendship": Icons.people,
    "Courage": Icons.shield,
    "Philosophy": Icons.psychology,
    "Growth": Icons.trending_up,
    "Faith": Icons.auto_awesome,
    "Adventure": Icons.explore,
    "Inspiration": Icons.bolt,
    "Kindness": Icons.volunteer_activism,
  };

  /// Returns an icon for a category.
  /// If the category is not in the map, a default icon is used.
  static IconData forCategory(String category) {
    return map[category] ?? Icons.menu_book; // fallback icon
  }
}

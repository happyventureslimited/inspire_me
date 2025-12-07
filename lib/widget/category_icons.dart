import 'package:flutter/material.dart';

class CategoryIcons {
  static final Map<String, IconData> map = {
    "Adventure": Icons.explore,
    "Courage": Icons.shield,
    "Faith": Icons.auto_awesome,
    "Friendship": Icons.people,
    "Growth": Icons.trending_up,
    "Happiness": Icons.sentiment_satisfied,
    "Inspiration": Icons.bolt,
    "Kindness": Icons.volunteer_activism,
    "Life": Icons.self_improvement,
    "Love": Icons.favorite,
    "Motivational": Icons.flash_on,
    "Philosophy": Icons.psychology,
    "Spiritual": Icons.light_mode,
    "Success": Icons.emoji_events,
    "Wisdom": Icons.menu_book,
  };

  static IconData forCategory(String category) {
    return map[category] ?? Icons.menu_book;
  }
}

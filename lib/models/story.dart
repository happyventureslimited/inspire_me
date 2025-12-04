import 'package:isar/isar.dart';
part 'story.g.dart';

@collection
class Story {
  Id id = Isar.autoIncrement;

  late String category;
  late String title;
  late String content;
  late String lesson;

  bool isSaved = false;
}
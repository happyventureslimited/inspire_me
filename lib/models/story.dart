import 'package:isar_plus/isar_plus.dart';
part 'story.g.dart';

@collection
class Story {
  @Id()
  int id = 0;

  late String category;
  late String title;
  late String content;
  late String lesson;

  bool isSaved = false;
}
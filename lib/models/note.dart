import 'package:isar_plus/isar_plus.dart';

part 'note.g.dart';

@collection
class Note {
  @Id()
  int id = 0;

  late String content;
  late DateTime createdAt;
}
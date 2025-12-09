import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/story.dart';
import '../models/note.dart';

class IsarService {
  late Isar isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      StorySchema,
      NoteSchema,
    ], directory: dir.path);
  }
}
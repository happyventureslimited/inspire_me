import 'package:isar_plus/isar_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../models/story.dart';
import '../models/note.dart';

class IsarService {
  late Isar isar;

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = Isar.open(
      schemas: [StorySchema, NoteSchema],
      directory: dir.path
    );
  }
}
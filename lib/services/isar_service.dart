import 'package:isar/isar.dart';
import 'package:hitomemo/models/profile.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<void> addProfile(Profile newProfile) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.profiles.putSync(newProfile));
  }

  Future<List<Profile>> getAllProfiles() async {
    final isar = await db;
    return await isar.profiles.where().findAll();
  }

  Stream<List<Profile>> listenToProfiles() async* {
    final isar = await db;
    yield* isar.profiles.where().watch(); // 初回の要素リストを最初に返す
  }

  Future<void> clearDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [ProfileSchema],
        inspector: true,
        directory: dir.path,
      );
    }

    return Future.value(Isar.getInstance());
  }
}

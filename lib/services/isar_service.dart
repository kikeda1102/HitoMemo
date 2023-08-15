import 'package:isar/isar.dart';
import 'package:hitomemo/models/profile.dart';
import 'package:hitomemo/models/general_tag.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [ProfileSchema, GeneralTagSchema],
        inspector: true,
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> clearDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  // Profile
  // create
  Future<void> addProfile(Profile newProfile) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.profiles.putSync(newProfile));
  }

  // read
  Future<List<Profile>> getAllProfiles() async {
    final isar = await db;
    return await isar.profiles.where().findAll();
  }

  Stream<List<Profile>> listenToProfiles() async* {
    final isar = await db;
    yield* isar.profiles.where().watch(fireImmediately: true); // 初回の要素リストを最初に返す
  }

  // delete
  Future<void> deleteProfile(Profile profile) async {
    final isar = await db;
    await isar.writeTxn(() => isar.profiles.delete(profile.id));
  }

  // GeneralTag
  // create
  Future<void> addGeneralTag(GeneralTag newGeneralTag) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.generalTags.putSync(newGeneralTag));
  }

  // read
  Future<List<GeneralTag>> getAllGeneralTags() async {
    final isar = await db;
    return await isar.generalTags.where().findAll();
  }

  // delete
  Future<void> deleteGeneralTag(GeneralTag generalTag) async {
    final isar = await db;
    await isar.writeTxn(() => isar.generalTags.delete(generalTag.id));
  }
}

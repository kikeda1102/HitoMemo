import 'package:isar/isar.dart';
import 'package:hitomemo/models/profile.dart';
import 'package:hitomemo/models/general_tag.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

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

  // // isEmpty
  // Future<bool> isEmpty() async {
  //   final isar = await db;
  //   // collectionの数を取得
  //   final count = await isar.profiles.where().count();
  //   return count == 0;
  // }

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

  // idでread
  Future<Profile?> getProfileById(int id) async {
    final isar = await db;
    return await isar.profiles.get(id);
  }

  Stream<List<Profile>> listenToProfiles() async* {
    final isar = await db;
    yield* isar.profiles.where().watch(fireImmediately: true); // 初回の要素リストを最初に返す
  }

  // update
  Future<void> updateProfile(Profile profile) async {
    final isar = await db;
    await isar.writeTxn(() => isar.profiles.put(profile));
  }

  // idによるTagの追加
  Future<void> addTag(int id, String newText) async {
    final isar = await db;
    // profileを取得
    final profile = await isar.profiles.get(id);
    // profileのpersonalTagsに追加
    if (profile == null) throw Exception('profile is null');
    profile.personalTags = [...profile.personalTags, newText];
    // profileを更新
    await isar.writeTxn(() => isar.profiles.put(profile));
  }

  // Profilesを更新する
  Future<void> updateProfiles(List<Profile> profiles) async {
    final isar = await db;
    await isar.writeTxn(() => isar.profiles.putAll(profiles));
  }

  // delete
  Future<void> deleteProfile(Profile profile) async {
    final isar = await db;
    await isar.writeTxn(() => isar.profiles.delete(profile.id));
  }

  // delete by id
  Future<void> deleteProfileById(int id) async {
    final isar = await db;
    await isar.writeTxn(() => isar.profiles.delete(id));
  }

  // GeneralTag

  // create
  Future<void> addGeneralTag(GeneralTag newGeneralTag) async {
    final isar = await db;
    // 重複がないか判定

    // 重複がなければ書き込み
    isar.writeTxnSync<int>(() => isar.generalTags.putSync(newGeneralTag));
  }

  // read
  Future<List<GeneralTag>> getAllGeneralTags() async {
    final isar = await db;
    return await isar.generalTags.where().findAll();
  }

  Stream<List<GeneralTag>> listenToGeneralTags() async* {
    final isar = await db;
    yield* isar.generalTags.where().watch(fireImmediately: true);
  }

  Future<int> getGeneralTagCount() async {
    final isar = await db;
    return await isar.generalTags.where().count();
  }

  // delete
  Future<void> deleteGeneralTag(GeneralTag generalTag) async {
    final isar = await db;
    await isar.writeTxn(() => isar.generalTags.delete(generalTag.id));
  }
}

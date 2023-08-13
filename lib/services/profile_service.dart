import 'package:isar/isar.dart';
import 'package:hitomemo/models/profile.dart';

class ProfileService {
  const ProfileService(this.isar);
  final Isar isar;

  Stream<Profile> watchProfile(Id id) async* {
    final query = isar.profiles.where().idEqualTo(id);

    // クエリの結果を監視し、結果が得られるたびにresults.firstをyield（返す）します。
    // yieldキーワードはジェネレータ関数内で使用され、値をストリームに返すために使用されます。
    await for (final results in query.watch(fireImmediately: true)) {
      if (results.isNotEmpty) {
        yield results.first;
      }
    }
  }

  Stream<List<Profile>> watchAllProfiles() {
    final query = isar.profiles
        .where()
        .sortByUpdated()
        .build(); // Isarのprofilesテーブルからクエリを作成し、sortByUpdated()メソッドで結果を更新日時でソートしています。

    // クエリの結果を監視し、結果が得られるたびにresultsをyieldします。
    // 結果が空の場合は空のリストをyieldします。
    return query.watch();
  }

  // このメソッドは新しいprofileをデータベースに追加し、追加されたメモを返します。
  Future<Profile> addProfile(List<byte> imageBytes, String name,
      List<String> personalTags, String memo) async {
    final newProfile = Profile(
        imageBytes: imageBytes,
        name: name,
        personalTags: personalTags,
        memo: memo,
        updated: DateTime.now());
    await isar.writeTxn(() async {
      await isar.profiles.put(newProfile);
    });
    return newProfile;
  }

  // removeMemoというメソッドが定義されています。
  // このメソッドは指定されたidに基づいてメモをデータベースから削除します。
  removeProfile(int id) async {
    await isar.writeTxn(() async {
      await isar.profiles.delete(
          id); // isar.writeTxn()メソッドを使用してトランザクションを開始し、トランザクション内でデータベースからメモを削除します。
    });
  }
}

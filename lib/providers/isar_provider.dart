import 'package:hitomemo/models/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

part 'isar_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Isar> isar(IsarRef ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar =
      await Isar.open([ProfileSchema], directory: dir.path, inspector: true);
  // await _loadInitialData(isar);
  return isar;
}

// // 初期データをロードする
// Future<void> _loadInitialData(isar) async {
//   final profiles = await isar.profiles.where().findAll();
//   if (profiles.isEmpty) {
//     final profile = Profile(
//       name: 'Flutter太郎',
//       imageBytes: [],
//       personalTags: [],
//       memo: 'Flutterを使っています。',
//     );
//     await isar.profiles.put(profile);
//   }
// }

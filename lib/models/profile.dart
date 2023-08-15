import 'package:isar/isar.dart';

part 'profile.g.dart';

@Collection()
class Profile {
  Id id = Isar.autoIncrement;

  DateTime created;
  DateTime? updated;
  String name;
  List<byte>? imageBytes;
  List<String> personalTags;
  String memo;

  // コンストラクタ
  Profile({
    this.updated,
    required this.name,
    this.imageBytes,
    required this.personalTags,
    required this.memo,
  })  : id = Isar.autoIncrement,
        created = DateTime.now();

  // copyWithメソッドを実装
  Profile copyWith({
    int? id,
    DateTime? created,
    DateTime? updated,
    String? name,
    List<int>? imageBytes,
    List<String>? personalTags,
    String? memo,
  }) {
    return Profile(
      // id: id ?? this.id,
      // created: created ?? this.created,
      updated: updated ?? this.updated,
      name: name ?? this.name,
      imageBytes: imageBytes ?? this.imageBytes,
      personalTags: personalTags ?? this.personalTags,
      memo: memo ?? this.memo,
    );
  }
}

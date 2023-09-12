import 'package:isar/isar.dart';

part 'profile.g.dart';

@Collection()
class Profile {
  Id id;
  int order;
  DateTime created;
  DateTime? updated;
  String name;
  List<byte>? imageBytes;
  List<String>? personalTags;
  String memo;

  // コンストラクタ
  Profile({
    this.id = Isar.autoIncrement,
    this.order = -1,
    this.updated,
    required this.name,
    this.imageBytes,
    required this.personalTags,
    required this.memo,
  }) : created = DateTime.now();

  // copyWithメソッドを実装
  Profile copyWith({
    int? id,
    int? order,
    DateTime? created,
    DateTime? updated,
    String? name,
    List<int>? imageBytes,
    List<String>? personalTags,
    String? memo,
  }) {
    return Profile(
      id: id ?? this.id,
      order: order ?? this.order,
      // created: created ?? this.created,
      updated: updated ?? this.updated,
      name: name ?? this.name,
      imageBytes: imageBytes ?? this.imageBytes,
      personalTags: personalTags ?? this.personalTags,
      memo: memo ?? this.memo,
    );
  }
}

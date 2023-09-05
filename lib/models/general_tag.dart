import 'package:isar/isar.dart';
part 'general_tag.g.dart';

@Collection()
class GeneralTag {
  Id id = Isar.autoIncrement;

  final String title;

  GeneralTag({required this.title});

  // hashcodeと==を実装
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is GeneralTag) {
      return runtimeType == other.runtimeType && title == other.title;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => title.hashCode;
}

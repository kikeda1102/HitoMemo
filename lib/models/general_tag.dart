import 'package:isar/isar.dart';
part 'general_tag.g.dart';

@Collection()
class GeneralTag {
  Id id = Isar.autoIncrement;

  final String name;

  GeneralTag({required this.name});
}

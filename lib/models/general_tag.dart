import 'package:isar/isar.dart';
part 'general_tag.g.dart';

@Collection()
class GeneralTag {
  Id id = Isar.autoIncrement;

  final String title;

  GeneralTag({required this.title});
}

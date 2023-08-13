import 'package:hitomemo/models/profile.dart';
import 'package:hitomemo/providers/isar_provider.dart';
import 'package:hitomemo/services/profile_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:isar/isar.dart';

part 'profile_service_provider.g.dart';

@Riverpod(keepAlive: true)
Future<ProfileService> profileService(ProfileServiceRef ref) async {
  final isar = await ref.watch(isarProvider.future);
  return ProfileService(isar);
}

@riverpod
Stream<Profile> profileDetail(ProfileDetailRef ref, Id id) async* {
  final service = await ref.watch(profileServiceProvider.future);
  yield* service.watchProfile(id);
}

@riverpod
Stream<List<Profile>> profileList(ProfileListRef ref) async* {
  final service = await ref.watch(profileServiceProvider.future);
  yield* service.watchAllProfiles();
}

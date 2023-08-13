// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileServiceHash() => r'392e6d686ddd5c691e080bbaa7078c78100d2f3b';

/// See also [profileService].
@ProviderFor(profileService)
final profileServiceProvider = FutureProvider<ProfileService>.internal(
  profileService,
  name: r'profileServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProfileServiceRef = FutureProviderRef<ProfileService>;
String _$profileDetailHash() => r'5262dbaa2c44c8441ac1597492a795df1e45d350';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef ProfileDetailRef = AutoDisposeStreamProviderRef<Profile>;

/// See also [profileDetail].
@ProviderFor(profileDetail)
const profileDetailProvider = ProfileDetailFamily();

/// See also [profileDetail].
class ProfileDetailFamily extends Family<AsyncValue<Profile>> {
  /// See also [profileDetail].
  const ProfileDetailFamily();

  /// See also [profileDetail].
  ProfileDetailProvider call(
    int id,
  ) {
    return ProfileDetailProvider(
      id,
    );
  }

  @override
  ProfileDetailProvider getProviderOverride(
    covariant ProfileDetailProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'profileDetailProvider';
}

/// See also [profileDetail].
class ProfileDetailProvider extends AutoDisposeStreamProvider<Profile> {
  /// See also [profileDetail].
  ProfileDetailProvider(
    this.id,
  ) : super.internal(
          (ref) => profileDetail(
            ref,
            id,
          ),
          from: profileDetailProvider,
          name: r'profileDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$profileDetailHash,
          dependencies: ProfileDetailFamily._dependencies,
          allTransitiveDependencies:
              ProfileDetailFamily._allTransitiveDependencies,
        );

  final int id;

  @override
  bool operator ==(Object other) {
    return other is ProfileDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$profileListHash() => r'a16affd07a795604570891c6524468d7fbd09eae';

/// See also [profileList].
@ProviderFor(profileList)
final profileListProvider = AutoDisposeStreamProvider<List<Profile>>.internal(
  profileList,
  name: r'profileListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$profileListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProfileListRef = AutoDisposeStreamProviderRef<List<Profile>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member

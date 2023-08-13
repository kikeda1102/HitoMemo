import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hitomemo/providers/profile_service_provider.dart';

// Profile Detail
class ProfileDetailWidget extends ConsumerWidget {
  const ProfileDetailWidget(
    this.id, {
    super.key,
  });

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileDetailProvider(id)).value;

    if (profile == null) {
      return const SizedBox();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(profile.name),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile.name),
                Text(profile.memo),
                const SizedBox(height: 16),
                // 削除ボタン
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(profileServiceProvider.future)
                        .then((service) => service.removeProfile(profile.id));
                    Navigator.pop(context);
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ),
        ));
  }
}

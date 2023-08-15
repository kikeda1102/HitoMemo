import 'package:flutter/material.dart';
import 'package:hitomemo/models/profile.dart';
import 'package:hitomemo/services/isar_service.dart';

// Profile Detail Page
class ProfileDetailPage extends StatelessWidget {
  final Profile profile;
  final IsarService service;

  const ProfileDetailPage(
      {Key? key, required this.profile, required this.service})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(profile.name),
        ),
        body: Padding(
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
                  // TODO: 削除機能
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        ));
  }
}

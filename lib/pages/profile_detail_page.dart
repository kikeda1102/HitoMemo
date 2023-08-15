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
                  // 確認ダイアログを表示
                  showDialog(
                      context: context,
                      builder: (context) {
                        return _deleteDialog(context,
                            profile: profile, service: service);
                      });
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        ));
  }
}

// 削除確認ダイアログ
AlertDialog _deleteDialog(BuildContext context,
    {required Profile profile, required IsarService service}) {
  return AlertDialog(
    title: const Text('Delete'),
    content: const Text('Are you sure to delete?'),
    actions: [
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          service.deleteProfile(profile);
          // 2つ前のページに戻る
          int count = 0;
          Navigator.popUntil(context, (_) => count++ >= 2);
        },
        child: const Text('OK'),
      ),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:hitomemo/models/profile.dart';
import 'package:hitomemo/services/isar_service.dart';

// Profile Detail Page
// 編集も遷移なしで行える

class ProfileDetailPage extends StatefulWidget {
  final Profile profile;
  final IsarService service;
  const ProfileDetailPage(
      {super.key, required this.profile, required this.service});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  String? newName;
  String? newMemo;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.profile.name),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // 名前
                TextFormField(
                  onChanged: (value) {
                    newName = value;
                    widget.profile.name = newName!;
                    // 更新実行
                    widget.service.updateProfile(widget.profile);
                  },
                  controller: TextEditingController(text: widget.profile.name),
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the name.";
                    }
                    return null;
                  },
                  maxLength: 20, // 入力可能な文字数
                ),

                const SizedBox(height: 16),

                // Memo
                TextFormField(
                  onChanged: (value) {
                    newMemo = value;
                    widget.profile.memo = newMemo!;
                    // 更新実行
                    widget.service.updateProfile(widget.profile);
                  },
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  controller: TextEditingController(text: widget.profile.memo),
                  decoration: const InputDecoration(
                    labelText: 'Memo',
                    border: InputBorder.none,
                    // border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the memo.";
                    }
                    return null;
                  },
                  maxLength: 500, // 入力可能な文字数
                ),

                const SizedBox(height: 16),

                // タグ
                const Text('Tags', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 4,
                      runSpacing: -12,
                      children: widget.profile.personalTags
                          .map((tag) => InputChip(
                                label: Text(tag),
                                onDeleted: () {
                                  setState(() {
                                    widget.profile.personalTags.remove(tag);
                                    // 更新実行
                                    widget.service
                                        .updateProfile(widget.profile);
                                  });
                                },
                              ))
                          .toList(),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 更新ボタン
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // 更新を実行
                    //     if (newName != null) {
                    //       widget.profile.name = newName!;
                    //     }
                    //     if (newMemo != null) {
                    //       widget.profile.memo = newMemo!;
                    //     }
                    //     widget.service.updateProfile(widget.profile);
                    //     Navigator.pop(context);
                    //   },
                    //   child: const Text('Update'),
                    // ),
                    // 削除ボタン
                    ElevatedButton(
                      onPressed: () {
                        // 確認ダイアログを表示
                        showDialog(
                            context: context,
                            builder: (context) {
                              return _deleteDialog(context,
                                  profile: widget.profile,
                                  service: widget.service);
                            });
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
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
        // 色
        style: TextButton.styleFrom(
            backgroundColor: Colors.grey, foregroundColor: Colors.white),
        child: const Text('Cancel'),
      ),
      TextButton(
        onPressed: () {
          service.deleteProfile(profile);
          // 2つ前のページに戻る
          int count = 0;
          Navigator.popUntil(context, (_) => count++ >= 2);
        },
        // 色を赤に
        style: TextButton.styleFrom(
            backgroundColor: Colors.red, foregroundColor: Colors.white),
        child: const Text('Delete'),
      ),
    ],
  );
}

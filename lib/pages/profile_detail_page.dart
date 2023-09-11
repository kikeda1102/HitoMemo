import 'package:flutter/material.dart';
import 'package:hitomemo/models/profile.dart';
import 'package:hitomemo/pages/add_person_page.dart';
import 'package:hitomemo/services/isar_service.dart';

// Profile Detail Page
// 編集も遷移なしで行える

class ProfileDetailPage extends StatefulWidget {
  final int id;
  final IsarService service;
  const ProfileDetailPage({super.key, required this.id, required this.service});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  // profileの読み込み
  @override
  void initState() {
    Future(() async {
      profile = await widget.service.getProfileById(widget.id);
    });

    super.initState();
  }

  Profile? profile;
  String? newName;
  String? newMemo;
  // State更新メソッド
  void updateProfile() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(profile!.name),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // 名前
                  TextFormField(
                    onChanged: (value) {
                      newName = value;
                      profile!.name = newName!;
                      // 更新実行
                      widget.service.updateProfile(profile!);
                    },
                    controller: TextEditingController(text: profile!.name),
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
                      profile!.memo = newMemo!;
                      // 更新実行
                      widget.service.updateProfile(profile!);
                    },
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    controller: TextEditingController(text: profile!.memo),
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

                  // 新規タグ追加

                  // 既存タグ
                  const Text('Tags', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: profile!.personalTags
                            .map((tag) => InputChip(
                                  label: Text(tag),
                                  onDeleted: () {
                                    setState(() {
                                      profile!.personalTags.remove(tag);
                                      // 更新実行
                                      widget.service.updateProfile(profile!);
                                    });
                                  },
                                ))
                            .toList(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  AddTagWidget(
                      notifyParent: updateProfile,
                      service: widget.service,
                      newProfile: profile!),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 更新ボタン
                      // ElevatedButton(
                      //   onPressed: () {
                      //     // 更新を実行
                      //     if (newName != null) {
                      //       profile!.name = newName!;
                      //     }
                      //     if (newMemo != null) {
                      //       profile!.memo = newMemo!;
                      //     }
                      //     widget.service.updateProfile(profile!);
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
                                    profile: profile!, service: widget.service);
                              });
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ],
              ),
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
    content: const Text('Are you sure to delete this profile?'),
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

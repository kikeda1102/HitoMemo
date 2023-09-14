import 'package:flutter/material.dart';
import 'package:hitomemo/models/profile.dart';
import 'package:hitomemo/components/add_tag_widget.dart';
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
    super.initState();

    // Future(() async {
    //   profile = await widget.service.getProfileById(widget.id);
    // });
  }

  Profile profile = Profile(
    name: '',
    imageBytes: null,
    personalTags: List<String>.empty(growable: true),
    memo: '',
  );
  String? newName;
  String? newMemo;
  // List<String>? newPersonalTags;

  // State更新メソッド
  void updateProfile() {
    setState(() {});
  }

  // Tagの追加を行う関数を定義

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // title: Text('Profile'),
            ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: FutureBuilder<Profile?>(
                future: widget.service.getProfileById(widget.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // 読み込み中の表示
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    return const Text('No Tags');
                  }

                  // profileにsnapshot.dataを代入
                  // TODO: 更新されたとき再取得が必要
                  profile = snapshot.data!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // 名前
                      TextFormField(
                        onChanged: (value) {
                          newName = value;
                          snapshot.data!.name = newName!;
                          // 更新実行
                          widget.service.updateProfile(snapshot.data!);
                        },
                        controller:
                            TextEditingController(text: snapshot.data!.name),
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
                          snapshot.data!.memo = newMemo!;
                          // 更新実行
                          widget.service.updateProfile(snapshot.data!);
                        },
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        controller:
                            TextEditingController(text: snapshot.data!.memo),
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
                            // TODO: snapshot.data!.personalTagsを更新
                            children: snapshot.data!.personalTags
                                .map((tag) => InputChip(
                                      label: Text(tag),
                                      onDeleted: () {
                                        setState(() {
                                          profile.personalTags =
                                              snapshot.data!.personalTags;
                                          // 更新実行
                                          widget.service.updateProfile(profile);
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
                          addTagFunction: (value) {
                            widget.service.addTag(widget.id, value);
                          },
                          id: snapshot.data!.id),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // 更新ボタン
                          // ElevatedButton(
                          //   onPressed: () {
                          //     // 更新を実行
                          //     if (newName != null) {
                          //       snapshot.data!.name = newName!;
                          //     }
                          //     if (newMemo != null) {
                          //       snapshot.data!.memo = newMemo!;
                          //     }
                          //     widget.service.updateProfile(snapshot.data!);
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
                                        profile: snapshot.data!,
                                        service: widget.service);
                                  });
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  );
                },
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

import 'package:flutter/material.dart';
import 'package:hitomemo/services/isar_service.dart';
import 'package:hitomemo/models/profile.dart';
import 'package:hitomemo/components/add_tag_widget.dart';

// 追加画面

// Person追加画面
class AddPersonPage extends StatefulWidget {
  final IsarService service;
  const AddPersonPage({required this.service, Key? key}) : super(key: key);
  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  Profile profile = Profile(
    name: '',
    imageBytes: null,
    personalTags: List<String>.empty(growable: true),
    memo: '',
  );
  final _formKey = GlobalKey<FormState>();
  final _nameTextController = TextEditingController();
  final _memoTextController = TextEditingController();
  // State更新メソッド
  void updateProfile() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new person'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                // 名前
                Container(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                    onChanged: (value) {
                      profile.name = value;
                    },
                    controller: _nameTextController,
                    decoration: const InputDecoration(
                      labelText: 'Name*',
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
                ),
                const SizedBox(height: 20),

                // personalタグ
                // const Text('Personal tags', style: TextStyle(fontSize: 24)),
                // const SizedBox(height: 20),
                // 登録されたpersonal tagsを表示
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: profile.personalTags
                      .map((tag) => InputChip(
                            label: Text(tag),
                            onDeleted: () {
                              setState(() {
                                profile.personalTags.remove(tag);
                              });
                            },
                          ))
                      .toList(),
                ),

                const SizedBox(
                  height: 20,
                ),

                // タグ追加
                // AddTagWidget(
                //     notifyParent: updateProfile,
                //     service: widget.service,
                //     id: profile.id),

                const SizedBox(height: 20),

                // メモ
                Container(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextField(
                    onChanged: (value) {
                      profile.memo = value;
                    },
                    controller: _memoTextController,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      labelText: 'Memo',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 登録ボタン
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // profileの追加
                      widget.service.addProfile(profile);
                      // TODO: orderの更新
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('register'),
                ),

                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

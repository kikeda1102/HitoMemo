import 'package:flutter/material.dart';
import 'package:hitomemo/services/isar_service.dart';
import 'package:hitomemo/models/profile.dart';
import 'package:hitomemo/models/general_tag.dart';

// 追加画面

// Person追加画面
class AddPersonPage extends StatefulWidget {
  final IsarService service;
  const AddPersonPage({required this.service, Key? key}) : super(key: key);
  @override
  State<AddPersonPage> createState() => _AddPersonPageState();
}

class _AddPersonPageState extends State<AddPersonPage> {
  Profile newProfile = Profile(
    name: '',
    imageBytes: null,
    personalTags: [],
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
                      newProfile.name = value;
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
                  children: newProfile.personalTags
                      .map((tag) => InputChip(
                            label: Text(tag),
                            onDeleted: () {
                              setState(() {
                                newProfile.personalTags.remove(tag);
                              });
                            },
                          ))
                      .toList(),
                ),

                const SizedBox(
                  height: 20,
                ),

                // タグ追加
                AddTagWidget(
                    notifyParent: updateProfile,
                    service: widget.service,
                    newProfile: newProfile),

                const SizedBox(height: 20),

                // メモ
                Container(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextField(
                    onChanged: (value) {
                      newProfile.memo = value;
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
                      widget.service.addProfile(newProfile);
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

class AddTagWidget extends StatefulWidget {
  final Function() notifyParent;
  final IsarService service;
  final Profile newProfile;
  const AddTagWidget(
      {required this.notifyParent,
      required this.service,
      required this.newProfile,
      super.key});

  @override
  State<AddTagWidget> createState() => _AddTagWidgetState();
}

class _AddTagWidgetState extends State<AddTagWidget> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Add Tags'),
      children: [
        // ユーザー入力によるタグ作成と登録
        Container(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: TextFormField(
            onFieldSubmitted: (value) {
              // personalタグに追加
              widget.newProfile.personalTags.add(value);
              // generalタグにも追加
              widget.service.addGeneralTag(GeneralTag(title: value));
              widget.notifyParent();
            },
            decoration: const InputDecoration(
              labelText: 'Create new tag',
              border: UnderlineInputBorder(),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // generalタグ
        Container(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: const ListTile(
            title: Text('Choose from general tags'),
          ),
        ),
        FutureBuilder<List<GeneralTag>>(
          future: widget.service.getAllGeneralTags(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // 読み込み中の表示
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No general tags available');
            }

            List<GeneralTag> generalTags = snapshot.data!;
            List<GeneralTag> toggledTags = [];

            return Wrap(
              spacing: 5,
              runSpacing: 5,
              children: generalTags
                  .map(
                    (tag) => FilterChip(
                      label: Text(tag.title),
                      onSelected: (isSelected) {
                        if (isSelected) {
                          widget.newProfile.personalTags.add(tag.title);
                        } else {
                          widget.newProfile.personalTags.remove(tag.title);
                        }
                        toggledTags.add(tag);
                        widget.notifyParent();
                      },
                      selected: toggledTags.contains(tag),
                    ),
                  )
                  .toList(),
            );
          },
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

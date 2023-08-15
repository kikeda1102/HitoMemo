import 'package:flutter/material.dart';
import 'package:hitomemo/services/isar_service.dart';
import 'package:hitomemo/models/profile.dart';

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
  bool _isGeneralTagsExpanded = false;

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
                const Text('Personal tags', style: TextStyle(fontSize: 24)),
                // 登録されたpersonal tagsを表示
                Wrap(
                  spacing: 8,
                  runSpacing: -2,
                  children: newProfile.personalTags
                      .map((tag) => Chip(label: Text(tag)))
                      .toList(),
                ),

                // ユーザー入力によるタグ作成と登録
                Container(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextFormField(
                    onFieldSubmitted: (value) {
                      setState(() {
                        newProfile.personalTags.add(value);
                      });
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
                  child: ListTile(
                    title: const Text('Choose from general tags'),
                    onTap: () {
                      setState(() {
                        _isGeneralTagsExpanded = !_isGeneralTagsExpanded;
                      });
                    },
                    trailing: _isGeneralTagsExpanded
                        ? const Icon(Icons.expand_less)
                        : const Icon(Icons.expand_more),
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox(),
                  secondChild: Wrap(
  spacing: 10,
  runSpacing: -8,
  children: 
      .then((tags) {
        return tags.map(
          (tag) => FilterChip(
            label: Text(tag),
            onSelected: (isSelected) {
              setState(() {
                if (isSelected) {
                  newProfile.personalTags.add(tag);
                } else {
                  newProfile.personalTags.remove(tag);
                }
                generalTags.toggleTag(tag);
              });
            },
            selected: generalTags.isTagToggled(tag),
          ),
        ).toList();
      }),
),

                  crossFadeState: _isGeneralTagsExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 200),
                ),

                const SizedBox(height: 20),

                // メモ
                Container(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: TextField(
                    onChanged: (value) {
                      newProfile.memo = value;
                    },
                    controller: _memoTextController,
                    decoration: const InputDecoration(
                      labelText: 'Memo',
                      border: OutlineInputBorder(),
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

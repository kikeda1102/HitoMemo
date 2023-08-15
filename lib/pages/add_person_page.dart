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

  List<String> generalTags = ['friend', 'family', 'colleague'];
  bool isGeneralTagsExpanded = false;
  final _nameTextController = TextEditingController();
  final _memoTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new person'),
      ),
      body: SingleChildScrollView(
        child: Center(
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
                ),
              ),
              const SizedBox(height: 20),

              // personalタグ
              const Text('Personal tags', style: TextStyle(fontSize: 24)),
              Wrap(
                spacing: 8,
                runSpacing: -2,
                children: newProfile
                    .personalTags
                    .map((tag) => Chip(label: Text(tag)))
                    .toList(),
              ),

              const SizedBox(height: 20),

              // generalタグ
              Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: ListTile(
                  title: const Text('Choose from general tags'),
                  onTap: () {
                    setState(() {
                      isGeneralTagsExpanded = !isGeneralTagsExpanded;
                    });
                  },
                  trailing: isGeneralTagsExpanded
                      ? const Icon(Icons.expand_less)
                      : const Icon(Icons.expand_more),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox(),
                secondChild: Wrap(
                  spacing: 10,
                  runSpacing: -8,
                  children: generalTags
                      .map(
                        (tag) => FilterChip(
                          label: Text(tag),
                          onSelected: (isSelected) {
                            // ToggleがTrueの場合は、PersonalTagsからタグを削除
                            if (isSelected) {
                              newProfile.personalTags.remove(tag);
                            } else {
                              // ToggleがFalseの場合は、PersonalTagsにタグを追加
                              newProfile.personalTags.add(tag);                              
                            }
                            // タグの選択状態をトグル
                            generalTags.toggleTag(tag);
                          },
                          selected: generalTags.isTagToggled(tag), // 選択状態を反映
                        ),
                      )
                      .toList(),
                ),
                crossFadeState: .isExpanded
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
                  if (newName.isNotEmpty) {
                    // profileの作成
                    ref.read(newProfileProvider.notifier).createNewProfile(
                          newName: newName,
                          newImageBytes: newImageBytes,
                          newPersonalTags:
                              ref.watch(newProfileProvider).personalTags,
                          newMemo: newMemo,
                        );
                    // profileの追加
                    ref.read(profileServiceProvider.future).then((service) =>
                        service.addProfile(
                            newImageBytes,
                            newName,
                            ref.watch(newProfileProvider).personalTags,
                            newMemo));
                    // 閉じて元の画面に戻る
                    Navigator.pop(context);
                  } else {
                    // 名前が入力されていない場合はエラーを発生させる
                    ref.read(nameErrorProvider.notifier).invokeError();
                  }
                  // TODO: newName, ... の初期化
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
    );
  }
}

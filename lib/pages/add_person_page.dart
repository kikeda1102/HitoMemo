import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:hitomemo/models/profile.dart';

// 追加画面

// Person追加画面
class AddPersonPage extends StatefulWidget {
  const AddPersonPage({Key? key}) : super(key: key);

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
                child: TextField(
                  onChanged: (value) {
                    newName = value;
                    ref.read(nameErrorProvider.notifier).revokeError();
                  },
                  controller: ref.watch(nameTextControllerProvider),
                  decoration: InputDecoration(
                    labelText: 'Name*',
                    border: const UnderlineInputBorder(),
                    errorText: ref.watch(nameErrorProvider)
                        ? 'Please enter the name.'
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // personalタグ
              const Text('Personal tags', style: TextStyle(fontSize: 24)),
              Wrap(
                spacing: 8,
                runSpacing: -2,
                children: ref
                    .watch(newProfileProvider)
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
                    generalTags.toggleExpanded(); // generalタグの展開
                  },
                  trailing: ref.watch(generalTagsProvider).isExpanded
                      ? const Icon(Icons.expand_less)
                      : const Icon(Icons.expand_more),
                ),
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox(),
                secondChild: Wrap(
                  spacing: 10,
                  runSpacing: -8,
                  children: GeneralTagsNotifier.generalTags
                      .map(
                        (tag) => FilterChip(
                          label: Text(tag),
                          onSelected: (isSelected) {
                            // ToggleがTrueの場合は、PersonalTagsからタグを削除
                            if (isSelected) {
                              ref
                                  .read(newProfileProvider.notifier)
                                  .addPersonalTags(newPersonalTags: [tag]);
                            } else {
                              ref
                                  .read(newProfileProvider.notifier)
                                  .removePersonalTags(newPersonalTags: [tag]);
                            }
                            // タグの選択状態をトグル
                            generalTags.toggleTag(tag);
                          },
                          selected: generalTags.isTagToggled(tag), // 選択状態を反映
                        ),
                      )
                      .toList(),
                ),
                crossFadeState: ref.watch(generalTagsProvider).isExpanded
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
                    newMemo = value;
                  },
                  controller: ref.watch(memoTextControllerProvider),
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

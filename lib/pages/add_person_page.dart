import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:flutter/services.dart';
import 'package:hitomemo/models/profile.dart';
import 'package:hitomemo/providers/profile_service_provider.dart';

// 追加画面

// Profileを管理するProvider
final newProfileProvider =
    StateNotifierProvider.autoDispose<NewProfileNotifier, Profile>((ref) {
  return NewProfileNotifier();
});

class NewProfileNotifier extends StateNotifier<Profile> {
  NewProfileNotifier()
      : super(Profile(
          updated: DateTime.now(),
          name: '',
          imageBytes: Uint8List(0),
          personalTags: <String>[],
          memo: '',
        ));

  // getter
  Profile get newProfile => state;

  // 初期化
  void initializeProfile() {
    state = state.copyWith(
      updated: DateTime.now(),
      name: '',
      imageBytes: Uint8List(0),
      personalTags: [],
      memo: '',
    );
  }

  // newProfileの作成
  void createNewProfile({
    required String newName,
    List<byte> newImageBytes = const [],
    List<String>? newPersonalTags,
    String? newMemo,
  }) {
    state = state.copyWith(
      name: newName,
      imageBytes: state.imageBytes,
      personalTags: newPersonalTags ?? state.personalTags,
      memo: newMemo ?? state.memo,
    );
  }

  // personalTagsの追加
  void addPersonalTags({
    List<String>? newPersonalTags,
  }) {
    state = state.copyWith(
      personalTags: [...state.personalTags, ...newPersonalTags!],
    );
  }

  // personalTagsの削除
  void removePersonalTags({
    List<String>? newPersonalTags,
  }) {
    state = state.copyWith(
      personalTags: [
        for (final tag in state.personalTags)
          if (!newPersonalTags!.contains(tag)) tag
      ],
    );
  }
}

// 名前が入力されているかのエラーを管理するProvider
final nameErrorProvider =
    StateNotifierProvider.autoDispose<NameErrorNotifier, bool>(
        (ref) => NameErrorNotifier());

class NameErrorNotifier extends StateNotifier<bool> {
  NameErrorNotifier() : super(false);

  void invokeError() {
    state = true;
  }

  void revokeError() {
    state = false;
  }
}

// 全体で共有される一般タグ
final generalTagsProvider =
    ChangeNotifierProvider.autoDispose<GeneralTagsNotifier>(
        (ref) => GeneralTagsNotifier());

class GeneralTagsNotifier extends ChangeNotifier {
  static final List<String> generalTags = [
    'male',
    'female',
    'Friends',
    'Colleagues',
  ];

  Set<String> toggledOnGeneralTags = {}; // トグルオンされたタグを格納するSet

  bool _isExpanded = false;

  bool get isExpanded => _isExpanded;

  void toggleExpanded() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  void toggleTag(String tag) {
    if (toggledOnGeneralTags.contains(tag)) {
      toggledOnGeneralTags.remove(tag);
    } else {
      toggledOnGeneralTags.add(tag);
    }
    notifyListeners();
  }

  bool isTagToggled(String tag) {
    return toggledOnGeneralTags.contains(tag);
  }

  void resetGeneralTags() {
    toggledOnGeneralTags.clear();
    _isExpanded = false;
    notifyListeners();
  }
}

// NameのTextFieldのコントローラー
final nameTextControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
  (ref) => TextEditingController(),
);

// MemoのTextFieldのコントローラー
final memoTextControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
  (ref) => TextEditingController(),
);

// 入力される情報
// TODO: 登録時に値が残っている
String newName = '';
List<byte> newImageBytes = const [];
List<String> newPersonalTags = <String>[];
String newMemo = '';

// Person追加画面
class AddPersonPage extends ConsumerWidget {
  const AddPersonPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final generalTags = ref.watch(generalTagsProvider);

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

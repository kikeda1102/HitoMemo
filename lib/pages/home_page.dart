import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:hitomemo/pages/add_person_page.dart';
import 'package:hitomemo/pages/profile_detail_page.dart';
import 'package:hitomemo/services/isar_service.dart';
import 'package:hitomemo/models/profile.dart';
import 'package:hitomemo/pages/tag_management_page.dart';
// import 'package:hitomemo/pages/settings_page.dart';

// ホーム画面
class HomePage extends StatelessWidget {
  final IsarService service;
  const HomePage({required this.service, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(
        children: [
          const ListTile(
            title: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text('HitoMemo'),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Version: 1.0.0'),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Link(
            // 開きたいWebページのURLを指定
            uri: Uri.parse(
                'https://kikeda1102.github.io/tt_scoreboard_LP/'), // GitHub Pages
            target: LinkTarget.self, // 独立したブラウザとして開く
            builder: (BuildContext ctx, FollowLink? openLink) {
              return TextButton.icon(
                onPressed: openLink,
                label: const Text('Privacy Policy'),
                icon: const Icon(Icons.open_in_new),
              );
            },
          ),
        ],
      )),
      appBar: AppBar(
        title: const Text('People List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // 検索
              showSearch(
                context: context,
                delegate: ProfileSearchDelegate(service: service),
              );
            },
          ),
        ],
      ),
      // リスト表示
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: StreamBuilder<List<Profile>>(
                stream: service.listenToProfiles(),
                builder: (context, AsyncSnapshot<List<Profile>> snapshot) {
                  if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                    // sort
                    snapshot.data!.sort((a, b) => a.order.compareTo(b.order));
                    // ReorderableListView
                    return ReorderableListView.builder(
                      onReorder: (oldIndex, newIndex) {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        // 順番を入れ替え
                        final item = snapshot.data!
                            .removeAt(oldIndex); // oldIndexを削除し、中身をitemに代入
                        snapshot.data!
                            .insert(newIndex, item); // newIndexにitemを挿入
                        // idにindexの値を代入、db更新
                        for (var i = 0; i < snapshot.data!.length; i++) {
                          // index代入
                          snapshot.data![i] = snapshot.data![i].copyWith(
                            order: i,
                          );
                          // dbに追加
                          service.updateProfile(snapshot.data![i]);
                        }
                      },
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final profile = snapshot.data![index];

                        return ListTile(
                          key: Key(profile.id.toString()),
                          title: Text(profile.name),
                          trailing: Text(profile.memo),
                          // タグ
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(profile.order.toString()),
                              if (profile.personalTags.isNotEmpty)
                                Wrap(
                                  spacing: 4,
                                  runSpacing: -12,
                                  children: profile.personalTags
                                      .map((tag) => Chip(
                                            label: Text(
                                              tag,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ))
                                      .toList(),
                                ),
                            ],
                          ),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ProfileDetailPage(
                                    profile: profile, service: service)),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error occurred'));
                  } else {
                    return const Center(
                        child: Text(
                      'Add a new person by tapping the + button.',
                      style: TextStyle(fontSize: 15),
                    ));
                  }
                },
              ),
            ),
          ),
        ],
      ),

      // create
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => AddPersonPage(service: service),
      //       )),
      //   tooltip: 'Add',
      //   child: const Icon(Icons.add),
      // ),

      bottomNavigationBar: PreferredSize(
        preferredSize: const Size.fromHeight(20),
        child: BottomAppBar(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // タグ
                TextButton(
                  onPressed: () {
                    // タグ管理画面へ遷移
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TagManagementPage(service: service),
                        ));
                  },
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 4),
                      Icon(
                        Icons.tag,
                        // color: Colors.white,
                        // size: 30,
                      ),
                      Text('Tags', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),

                // 新規追加
                TextButton(
                  onPressed: () {
                    // 設定画面へ遷移
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddPersonPage(
                            service: service,
                          ),
                        ));
                  },
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 4),
                      Icon(
                        Icons.add_circle,
                        // color: Colors.white,
                        // size: 30,
                      ),
                      Text('New', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ),

                // メニュー
                // TextButton(
                //   onPressed: () {
                //     // 設定画面へ遷移
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => SettingsPage(),
                //         ));
                //   },
                //   child: const Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       SizedBox(height: 4),
                //       Icon(
                //         Icons.menu,
                //         // color: Colors.white,
                //         // size: 30,
                //       ),
                //       Text('Menu', style: TextStyle(fontSize: 10)),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 検索機能
class ProfileSearchDelegate extends SearchDelegate<Profile> {
  final IsarService service;
  // final TextStyle searchFieldStyle = const TextStyle(fontSize: 15);
  ProfileSearchDelegate(
      {required this.service,
      super.searchFieldStyle = const TextStyle(color: Colors.white)});

  // 色の設定
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      primaryColor: Colors.blueGrey,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      // 検索クエリをクリアするボタン
      IconButton(
        icon: const Icon(Icons.clear),
        tooltip: 'Clear',
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  // 検索バーの左側の戻るボタン
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      tooltip: 'Back',
      onPressed: () => close(
          context,
          Profile(
            name: '',
            memo: '',
            personalTags: [],
          )),
    );
  }

  // 検索結果の表示
  @override
  Widget buildResults(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<Profile>>(
        stream: service.listenToProfiles(),
        builder: (context, AsyncSnapshot<List<Profile>> snapshot) {
          if (snapshot.data != null && snapshot.data!.isNotEmpty) {
            final results = snapshot.data!
                .where((profile) =>
                    profile.name.toLowerCase().contains(query.toLowerCase()) ||
                    profile.personalTags.any((tag) =>
                        tag.toLowerCase().contains(query.toLowerCase())) ||
                    profile.memo.toLowerCase().contains(query.toLowerCase()))
                .toList();
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: Colors.grey,
                thickness: 1.0,
              ),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final profile = results[index];
                return ListTile(
                  title: Text(profile.name),
                  trailing: Text(profile.memo),
                  // タグ
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (profile.personalTags.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          runSpacing: -12,
                          children: profile.personalTags
                              .map((tag) => Chip(
                                    label: Text(
                                      tag,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ))
                              .toList(),
                        ),
                    ],
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileDetailPage(profile: profile, service: service),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error occurred'));
          } else {
            return const Center(
                child: Text(
              'Add a new person by tapping the + button.',
              style: TextStyle(fontSize: 15),
            ));
          }
        },
      ),
    );
  }

  // 検索候補の表示
  @override
  Widget buildSuggestions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<Profile>>(
        stream: service.listenToProfiles(),
        builder: (context, AsyncSnapshot<List<Profile>> snapshot) {
          if (snapshot.data != null && snapshot.data!.isNotEmpty) {
            final results = snapshot.data!
                .where((profile) =>
                    profile.name.toLowerCase().contains(query.toLowerCase()) ||
                    profile.personalTags.any((tag) =>
                        tag.toLowerCase().contains(query.toLowerCase())) ||
                    profile.memo.toLowerCase().contains(query.toLowerCase()))
                .toList();
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                color: Colors.grey,
                thickness: 1.0,
              ),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final profile = results[index];
                return ListTile(
                  title: Text(profile.name),
                  trailing: Text(profile.memo),
                  // タグ
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (profile.personalTags.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          runSpacing: -12,
                          children: profile.personalTags
                              .map((tag) => Chip(
                                    label: Text(
                                      tag,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ))
                              .toList(),
                        ),
                    ],
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileDetailPage(profile: profile, service: service),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error occurred'));
          } else {
            return const Center(
                child: Text(
              'Add a new person by tapping the + button.',
              style: TextStyle(fontSize: 15),
            ));
          }
        },
      ),
    );
  }
}

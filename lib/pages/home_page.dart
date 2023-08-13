import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hitomemo/pages/add_person_page.dart';
import 'package:hitomemo/pages/profile_detail_page.dart';
import 'package:hitomemo/providers/profile_service_provider.dart';

// ホーム画面
class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(profileListProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('People List'),
        actions: [
          // TODO: 検索機能
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // showSearch(
              //   context: context,
              //   delegate: PersonSearchDelegate(personList.personList),
              // );
            },
          ),
        ],
      ),
      // リスト表示
      body:
          // profiles
          profiles == null
              ? const Center(
                  child: Text('Add new person by tapping the + button.'))
              : ListView.separated(
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                  ),
                  itemCount: profiles.length,
                  itemBuilder: (context, index) {
                    final profile = profiles[index];
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
                                ProfileDetailWidget(profile.id)),
                      ),
                    );
                  },
                ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPersonPage(),
            )),
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: BottomAppBar(
          // color: Colors.blueGrey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // タグ
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.tag,
                  // color: Colors.white,
                  // size: 30,
                ),
                label: const Text('Tags'),
              ),
              // 設定
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.settings,
                  // color: Colors.white,
                  // size: 30,
                ),
                label: const Text('Settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hitomemo/services/isar_service.dart';
import 'package:hitomemo/models/profile.dart';
import 'package:hitomemo/models/general_tag.dart';
import 'package:hitomemo/pages/profile_detail_page.dart';

// タグ管理画面

class TagManagementPage extends StatefulWidget {
  final IsarService service;
  const TagManagementPage({required this.service, super.key});

  @override
  State<TagManagementPage> createState() => _TagManagementPageState();
}

class _TagManagementPageState extends State<TagManagementPage> {
  // 絞り込みするタグ
  List<GeneralTag> filteredTags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Tags', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            // generalタグ
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

                return Wrap(
                  spacing: 10,
                  runSpacing: -8,
                  children: generalTags
                      .map(
                        (tag) => FilterChip(
                          label: Text(tag.title),
                          onSelected: (isSelected) {
                            setState(() {
                              if (isSelected) {
                                filteredTags.add(tag);
                              } else {
                                filteredTags.remove(tag);
                              }
                            });
                          },
                          selected: filteredTags.contains(tag),
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 40),
            const Text('Results', style: TextStyle(fontSize: 20)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: StreamBuilder<List<Profile>>(
                  stream: widget.service.listenToProfiles(),
                  builder: (context, AsyncSnapshot<List<Profile>> snapshot) {
                    if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                      // タグで絞り込み
                      // filteredTagsの全てのタグを含むプロフィールを抽出
                      final filteredProfiles = snapshot.data!.where((profile) {
                        return filteredTags.every((tag) {
                          return profile.personalTags.contains(tag.title);
                        });
                      }).toList();

                      return ListView.separated(
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(
                          color: Colors.grey,
                          thickness: 1.0,
                        ),
                        itemCount: filteredProfiles.length,
                        itemBuilder: (context, index) {
                          final profile = filteredProfiles[index];
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
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                              ],
                            ),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ProfileDetailPage(
                                      profile: profile,
                                      service: widget.service)),
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
      ),
    );
  }
}

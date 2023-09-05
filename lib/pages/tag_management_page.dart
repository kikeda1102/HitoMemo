import 'package:flutter/material.dart';
import 'package:hitomemo/services/isar_service.dart';
import 'package:hitomemo/models/profile.dart';
import 'package:hitomemo/models/general_tag.dart';

// タグ管理画面

class TagManagementPage extends StatefulWidget {
  final IsarService service;
  const TagManagementPage({required this.service, super.key});

  @override
  State<TagManagementPage> createState() => _TagManagementPageState();
}

class _TagManagementPageState extends State<TagManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
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
                List<GeneralTag> toggledTags = [];

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
                                // newProfile.personalTags.add(tag.title);
                              } else {
                                // newProfile.personalTags.remove(tag.title);
                              }
                              toggledTags.add(tag);
                            });
                          },
                          selected: toggledTags.contains(tag),
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

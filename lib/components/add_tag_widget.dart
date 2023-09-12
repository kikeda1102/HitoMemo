import 'package:flutter/material.dart';
import 'package:hitomemo/services/isar_service.dart';
import 'package:hitomemo/models/profile.dart';
import 'package:hitomemo/models/general_tag.dart';

class AddTagWidget extends StatefulWidget {
  final Function() notifyParent;
  final IsarService service;
  final Profile profile;
  const AddTagWidget(
      {required this.notifyParent,
      required this.service,
      required this.profile,
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
              widget.profile.personalTags!.add(value);
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
                          widget.profile.personalTags!.add(tag.title);
                        } else {
                          widget.profile.personalTags!.remove(tag.title);
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

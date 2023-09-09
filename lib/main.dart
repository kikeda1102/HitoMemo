import 'package:flutter/material.dart';
import 'package:hitomemo/pages/home_page.dart';
import 'package:hitomemo/models/general_tag.dart';
import 'package:hitomemo/services/isar_service.dart';

// hitomemo 初対面の人のプロフィールを記録するメモアプリ
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // IsarServiceのインスタンスを生成
  final service = IsarService();
  // アプリケーションの初期化処理
  await initializeDb(service);
  // アプリケーションの起動
  runApp(MyApp(service: service));
}

Future<void> initializeDb(IsarService service) async {
  // generalTagがない場合は初期データを追加する
  if (await service.getGeneralTagCount() == 0) {
    await service.addGeneralTag(GeneralTag(title: 'Friend'));
  }
}

class MyApp extends StatelessWidget {
  final IsarService service;
  const MyApp({required this.service, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Debug BannerをOFFにする
      title: 'hitomemo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(service: service),
      // 変なレコード入れてしまった時用
      // home: const Placeholder(),
    );
  }
}

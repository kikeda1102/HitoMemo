import 'package:flutter/material.dart';
import 'package:hitomemo/pages/home_page.dart';

// hitomemo
// 初対面の人のプロフィールを記録し一覧表示できるメモアプリ
void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Debug BannerをOFFにする
      title: 'hitomemo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: HomePage(),
    );
  }
}

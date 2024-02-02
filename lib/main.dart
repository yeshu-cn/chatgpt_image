import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:chatgpt_image/home_page.dart';
import 'package:chatgpt_image/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (BuildContext context) => Settings(),
    child: const MyApp(),
  ));

  doWhenWindowReady(() {
    const initialSize = Size(1000, 600);
    appWindow.minSize = initialSize;
    appWindow.size = initialSize;
    appWindow.alignment = Alignment.center;
    appWindow.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 去掉右上角debug标签
      title: 'ChatGPT Image',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: WindowBorder(width: 1, color: const Color(0xFF805306),child: const HomePage(),),
    );
  }
}

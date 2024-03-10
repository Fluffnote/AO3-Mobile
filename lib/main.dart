import 'package:ao3mobile/pages/workView.dart';
import 'package:flutter/material.dart';

void main() {
  runApp (const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WorkView(),
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(255, 58, 71, 1.0)
      ),
    );
  }
}


import 'package:ao3mobile/layout/MainLayout.dart';
import 'package:ao3mobile/layout/ThemeSwitcher.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp (const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainLayout(),
      theme: ThemeSwitcher.instance.theme,
      navigatorKey: navigatorKey,
    );
  }
}


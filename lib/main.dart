import 'package:ao3mobile/data/DB/SDB.dart';
import 'package:ao3mobile/data/models/SearchData.dart';
import 'package:ao3mobile/data/models/Work.dart';
import 'package:ao3mobile/data/providers/Work_P.dart';
import 'package:ao3mobile/layout/MainLayout.dart';
import 'package:ao3mobile/layout/ThemeSwitcher.dart';
import 'package:flutter/material.dart';

import 'data/Singletons/ClientKeeper.dart';
import 'data/providers/Search_P.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {

  runApp (const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Future<void> init() async {
    // Load DBs
    await SDB.instance.library;
    await SDB.instance.history;
    await SDB.instance.temp;

    // Create api handler
    await ClientKeeper.instance.client;
  }

  @override
  Widget build(BuildContext context) {

    init();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainLayout(),
      theme: ThemeSwitcher.instance.theme,
      navigatorKey: navigatorKey,
    );
  }
}


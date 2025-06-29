import 'package:ao3mobile/data/Singletons/ClientKeeper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/retry.dart';
import 'package:sqflite/sqflite.dart';

import '../data/DB/DB.dart';
import '../views/historyView.dart';
import '../views/libraryView.dart';
import '../views/searchView.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late Database db;
  late RetryClient client;

  int _currentIndex = 0;
  ScrollController _scrollController = new ScrollController();

  bool _isVisible = true;

  final List<Widget> _tabs = [
    SearchView(),
    // Libraryview(),
    Historyview(),
    // SettingsScreen(),
  ];



  @override
  void initState() {
    super.initState();
    openDB();
    openClient();
  }

  @override
  void dispose() {
    // ClientKeeper.instance.closeClient();
    super.dispose();
  }



  Future<void> openDB() async => db = await DB.instance.database;
  Future<void> openClient() async => client = await ClientKeeper.instance.client;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).primaryColor,
        ),
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.collections_bookmark),
          //   label: 'Library',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   label: 'Settings',
          // ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings Screen'),
    );
  }
}
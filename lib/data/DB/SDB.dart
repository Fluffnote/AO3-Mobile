import 'package:sembast_sqflite/sembast_sqflite.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:sembast/sembast.dart';

class SDB {

  SDB._internal();
  static final SDB _sdb = new SDB._internal();
  static SDB get instance => _sdb;

  static var _library;
  static var _history;
  static var _temp;

  var factory = getDatabaseFactorySqflite(sqflite.databaseFactory);

  Future<Database> get library async {
    if(_library != null) return _library;
    _library = await _initLibrary();
    return _library;
  }

  Future<Database> get history async {
    if(_history != null) return _history;
    _history = await _initHistory();
    return _history;
  }

  Future<Database> get temp async {
    if(_temp != null) return _temp;
    _temp = await _initTemp();
    return _temp;
  }



  Future<Database> _initLibrary() async {
    factory.sqfliteImportPageSize = 1000;
    return await factory.openDatabase("AO3M_LIBRARY.db");
  }

  Future<Database> _initHistory() async {
    factory.sqfliteImportPageSize = 1000;
    return await factory.openDatabase("AO3M_HISTORY.db");
  }

  Future<Database> _initTemp() async {
    factory.sqfliteImportPageSize = 1000;

    // Resetting on init to remove old data
    if (await factory.databaseExists("AO3M_TEMP.db")) {
      await factory.deleteDatabase("AO3M_TEMP.db");
    }

    return await factory.openDatabase("AO3M_TEMP.db");
  }
}
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'DBSchema.dart';



const String DROP_WORK_CACHE = "DROP TABLE IF EXISTS WORK_CACHE;";
const String DROP_CHAPTER_CACHE = "DROP TABLE IF EXISTS CHAPTER_CACHE;";

class DB {

  static final DB _db = new DB._internal();
  DB._internal();
  static DB get instance => _db;
  static var _database;

  Future<Database> get database async {
    if(_database != null) return _database;
    _database = await _init();
    return _database;
  }

  Future<Database> _init() async{
    return await openDatabase(
      'AO3M.db',
      version: 1,
      onCreate: (db, version) {
        db.execute(DBSchema.CREATE_HISTORY);
        db.execute(DBSchema.CREATE_WORK);
        db.execute(DBSchema.CREATE_CHAPTER);
        db.execute(DBSchema.CREATE_SEARCH_RESULTS);
        db.execute(DBSchema.CREATE_FILTER);
        db.execute(DBSchema.CREATE_FILTER_COMPONENTS);
        // db.execute(DBSchema.CREATE_LIBRARY);
        // db.execute(DBSchema.CREATE_LABELS);
      },
      onOpen: (db) {
        if (kDebugMode) {
          print("Resetting cache");
        }
        db.execute(DROP_CHAPTER_CACHE);
        db.execute(DROP_WORK_CACHE);
        db.execute(DBSchema.CREATE_WORK_CACHE);
        db.execute(DBSchema.CREATE_CHAPTER_CACHE);
      }
    );
  }
}

class DBSet {
  String sql = "";
  List<Object> params = [];
  DBSet(this.sql, this.params);
}
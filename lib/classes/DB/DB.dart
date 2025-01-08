import 'package:sqflite/sqflite.dart';
import 'DBCommon.dart';
import 'DBSchema.dart';

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
        db.execute(DBSchema.HISTORY_CREATE);
        db.execute(DBSchema.WORK_CREATE);
        db.execute(DBSchema.CHAPTER_CREATE);
        db.execute(DBSchema.SEARCH_RESULTS_CREATE);
        db.execute(DBSchema.LIBRARY_CREATE);
        db.execute(DBSchema.LABELS_CREATE);
        db.execute(DBSchema.FILTERS_CREATE);
      },
      onOpen: (db) {
        db.execute(DBCommon.DROP_CHAPTER_CACHE);
        db.execute(DBCommon.DROP_WORK_CACHE);
        db.execute(DBSchema.WORK_CACHE_CREATE);
        db.execute(DBSchema.CHAPTER_CACHE_CREATE);
      }
    );
  }
}
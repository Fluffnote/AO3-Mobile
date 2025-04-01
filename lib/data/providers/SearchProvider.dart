import 'package:sqflite/sqflite.dart';

import '../DB/DB.dart';

class SearchProvider {

  SearchProvider();



  Future<void> addWorkToSearchResults(int workId) async {
    Database db = await DB.instance.database;
    var checkRes = await db.rawQuery("SELECT * FROM SEARCH_RESULTS WHERE WORK_ID = $workId;");
    if (checkRes.isEmpty) await db.rawInsert("INSERT INTO SEARCH_RESULTS (WORK_ID) VALUES ($workId);");
  }

  Future<void> clearSearchResults() async {
    Database db = await DB.instance.database;
    await db.rawQuery("DELETE FROM SEARCH_RESULTS;");
  }
}
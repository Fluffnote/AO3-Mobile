import 'package:sqflite/sqflite.dart';

import '../DB/DB.dart';
import '../models/Chapter.dart';
import '../models/Work.dart';

class HistoryProvider {

  HistoryProvider();



  // DB Queries & Sets
  static String CHECK_IF_HISTORY_EXISTS(int workId, int chapterId) {
    String sql = """
    SELECT * FROM HISTORY WHERE WORK_ID = $workId AND CHAP_ID = $chapterId;""";
    return sql;
  }

  static DBSet BUILD_INSERT_INTO_HISTORY(int workId, String workTitle, String workAuthor, int chapterId, String chapterNum, String chapterTitle) {
    String sql = """
    INSERT INTO HISTORY (WORK_ID, WORK_NAME, AUTHOR, CHAP_ID, CHAP_NUM, CHAP_NAME, POS, MAX_POS, ACCESS_DATE)
    VALUES (?, ?, ?, ?, ?, ?, 0, 0, CURRENT_TIMESTAMP);""";
    List<Object> params = [
      workId,
      workTitle,
      workAuthor,
      chapterId,
      chapterNum,
      chapterTitle
    ];
    return DBSet(sql, params);
  }

  static DBSet BUILD_UPDATE_INTO_HISTORY(int workId, String workTitle, int chapterId, String chapterNum, String chapterTitle) {
    String sql = """
    UPDATE HISTORY SET 
      WORK_NAME = ?, CHAP_NUM = ?, CHAP_NAME = ?, ACCESS_DATE = CURRENT_TIMESTAMP
    WHERE WORK_ID = $workId AND CHAP_ID = $chapterId;""";
    List<Object> params = [
      workTitle,
      chapterNum,
      chapterTitle
    ];
    return DBSet(sql, params);
  }

  static DBSet UPDATE_HISTORY_POS(int workId, int chapterId, double pos, double maxPos) {
    String sql = """
    UPDATE HISTORY SET 
      POS = ?, MAX_POS = ?, ACCESS_DATE = CURRENT_TIMESTAMP
    WHERE WORK_ID = $workId AND CHAP_ID = $chapterId;""";
    List<Object> params = [
      pos,
      maxPos
    ];
    return DBSet(sql, params);
  }

  static String GET_HISTORY_LIST() {
    String sql = """
    WITH HIGHEST_CHAPTER AS (
      SELECT WORK_ID, MAX(ACCESS_DATE) AS ACCESS_DATE FROM HISTORY GROUP BY WORK_ID
    )
    SELECT *
    FROM HISTORY H
    JOIN HIGHEST_CHAPTER HC ON HC.WORK_ID = H.WORK_ID AND HC.ACCESS_DATE = H.ACCESS_DATE
    ORDER BY H.ACCESS_DATE DESC;""";
    return sql;
  }



  // Data manipulation functions
  Future<List<Map<String, Object?>>> getHistoryListData() async {
    Database db = await DB.instance.database;
    return await db.rawQuery(GET_HISTORY_LIST());
  }

  Future<void> addHistoryEntry(int workId, String workTitle, String workAuthor, int chapterId, String chapterNum, String chapterTitle) async {
    List<Map<String, Object?>> checkRes = await checkIfHistoryExists(workId, chapterId);
    if (checkRes.isEmpty) await insertIntoHistory(workId, workTitle, workAuthor, chapterId, chapterNum, chapterTitle);
    else await updateIntoHistory(workId, workTitle, chapterId, chapterNum, chapterTitle);
  }

  Future<List<Map<String, Object?>>> checkIfHistoryExists(int workId, int chapterId) async {
    Database db = await DB.instance.database;
    return await db.rawQuery(CHECK_IF_HISTORY_EXISTS(workId, chapterId));
  }

  Future<void> insertIntoHistory(int workId, String workTitle, String workAuthor, int chapterId, String chapterNum, String chapterTitle) async {
    Database db = await DB.instance.database;
    DBSet query = BUILD_INSERT_INTO_HISTORY(workId, workTitle, workAuthor, chapterId, chapterNum, chapterTitle);
    await db.rawInsert(query.sql, query.params);
  }

  Future<void> updateIntoHistory(int workId, String workTitle, int chapterId, String chapterNum, String chapterTitle) async {
    Database db = await DB.instance.database;
    DBSet query = BUILD_UPDATE_INTO_HISTORY(workId, workTitle, chapterId, chapterNum, chapterTitle);
    await db.rawUpdate(query.sql, query.params);
  }

  Future<void> updateHistoryPos(int workId, int chapterId, double pos, double maxPos) async {
    Database db = await DB.instance.database;
    DBSet query = UPDATE_HISTORY_POS(workId, chapterId, pos, maxPos);
    await db.rawUpdate(query.sql, query.params);
  }

  Future<void> deleteHistory(int workId) async {
    Database db = await DB.instance.database;
    await db.rawDelete("DELETE FROM HISTORY WHERE WORK_ID = $workId;");
  }
}
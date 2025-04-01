import 'package:sqflite/sqflite.dart';

import '../DB/DB.dart';
import '../models/Chapter.dart';



class ChapterProvider {

  ChapterProvider();

  static String CHECK_IF_CHAPTER_EXISTS(int workId, int chapterId) {
    String sql = """
    SELECT 'CHAPTER_CACHE' AS CHAPTER_TABLE FROM CHAPTER_CACHE WHERE WORK_ID = $workId AND CHAP_ID = $chapterId
    UNION
    SELECT 'CHAPTER' AS CHAPTER_TABLE FROM CHAPTER WHERE WORK_ID = $workId AND CHAP_ID = $chapterId;""";
    return sql;
  }

  static DBSet BUILD_INSERT_INTO_CHAPTER(Chapter chapter, bool cache, [bool updateFetch = true]) {
    String sql = """
    INSERT INTO CHAPTER${cache?"_CACHE":""} (WORK_ID, CHAP_ID, CHAP_ORDER, PART, CHAP_ID_NEXT, NUM, TITLE, SUMMARY, NOTES, BODY${updateFetch?", LAST_FETCH_DATE":""})
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?${updateFetch?", CURRENT_TIMESTAMP":""});""";
    List<Object> params = [
      chapter.workId,
      chapter.id,
      chapter.order,
      1,
      chapter.nextId,
      chapter.num,
      chapter.title,
      chapter.summary,
      chapter.notes,
      chapter.body
    ];
    return DBSet(sql, params);
  }

  static DBSet BUILD_UPDATE_INTO_CHAPTER(Chapter chapter, bool cache, [bool updateFetch = true]) {
    String sql = """
    UPDATE CHAPTER${cache?"_CACHE":""} SET
      CHAP_ORDER = ?, PART = ?, CHAP_ID_NEXT = ?, NUM = ?, TITLE = ?, SUMMARY = ?,
      NOTES = ?, BODY = ?${updateFetch?", LAST_FETCH_DATE = CURRENT_TIMESTAMP":""}
    WHERE WORK_ID = ${chapter.workId} AND CHAP_ID = ${chapter.id};""";
    List<Object> params = [
      chapter.order,
      1,
      chapter.nextId,
      chapter.num,
      chapter.title,
      chapter.summary,
      chapter.notes,
      chapter.body
    ];
    return DBSet(sql, params);
  }

  static String BUILD_CHAPTER_INFO_QUERY(String workTable, String chapterTable, int workId, int chapterId) {
    String sql = """
    SELECT W.TITLE AS WORK_TITLE, C.* FROM $chapterTable C
    JOIN $workTable W ON W.WORK_ID = C.WORK_ID
    WHERE C.WORK_ID = $workId
    AND C.CHAP_ID = $chapterId""";
    return sql;
  }



  Future<Map<String, Object?>> getChapterData(int workId, int chapterId) async {
    String table = await whichTableIsChapterIn(workId, chapterId);
    if (table == "NONE") return new Map();
    Database db = await DB.instance.database;
    List<Map<String, Object?>> results = await db.rawQuery(await buildChapterInfoQuery(workId, chapterId));

    if (results.isEmpty) return new Map();
    else return results.first;
  }

  Future<String> whichTableIsChapterIn(int workId, int chapterId) async {
    Database db = await DB.instance.database;
    List<Map<String, Object?>> checkRes = await db.rawQuery(CHECK_IF_CHAPTER_EXISTS(workId, chapterId));
    if (checkRes.isEmpty) return "NONE";
    else return (checkRes.first["CHAPTER_TABLE"] as String);
  }

  Future<bool> doesChapterNeedRefresh(int workId, int chapterId) async {
    Database db = await DB.instance.database;
    List<Map<String, Object?>> chapterCheckRes = await db.rawQuery(CHECK_IF_CHAPTER_EXISTS(workId, chapterId));
    if (chapterCheckRes.isNotEmpty) {
      String workTable = (chapterCheckRes.first["CHAPTER_TABLE"] as String) == "CHAPTER"?"WORK":"WORK_CACHE";
      List<Map<String, Object?>> workFetchRes = await db.rawQuery("SELECT LAST_FETCH_DATE FROM $workTable WHERE WORK_ID = $workId");
      List<Map<String, Object?>> chapterFetchRes = await db.rawQuery("SELECT LAST_FETCH_DATE FROM ${(chapterCheckRes.first["CHAPTER_TABLE"] as String)} WHERE WORK_ID = $workId AND CHAP_ID = $chapterId");
      if (workFetchRes.isNotEmpty && workFetchRes.first["LAST_FETCH_DATE"] != null && chapterFetchRes.isNotEmpty && chapterFetchRes.first["LAST_FETCH_DATE"] != null) {
        DateTime workFetchDate = DateTime.parse(workFetchRes.first["LAST_FETCH_DATE"] as String);
        DateTime chapterFetchDate = DateTime.parse(chapterFetchRes.first["LAST_FETCH_DATE"] as String);

        return chapterFetchDate.isBefore(workFetchDate);
      }
    }
    return true;
  }

  Future<void> addChapterToCache(Chapter chapter, [bool updateFetch = true]) async {
    Database db = await DB.instance.database;
    List<Map<String, Object?>> checkRes = await db.rawQuery(CHECK_IF_CHAPTER_EXISTS(chapter.workId, chapter.id));
    if (checkRes.isEmpty) {
      DBSet query = BUILD_INSERT_INTO_CHAPTER(chapter, true, updateFetch);
      await db.rawInsert(query.sql, query.params);
    }
    else {
      DBSet query = BUILD_UPDATE_INTO_CHAPTER(chapter, (checkRes.first.entries.first.value as String) == "CHAPTER_CACHE", updateFetch);
      await db.rawUpdate(query.sql, query.params);
    }
  }

  Future<String> buildChapterInfoQuery(int workId, int chapterId) async {
    String chapterTable = await whichTableIsChapterIn(workId, chapterId);
    String workTable = chapterTable == "CHAPTER"?"WORK":"WORK_CACHE";
    return BUILD_CHAPTER_INFO_QUERY(workTable, chapterTable, workId, chapterId);
  }
}
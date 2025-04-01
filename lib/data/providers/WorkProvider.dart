import 'dart:collection';

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../DB/DB.dart';
import '../models/Work.dart';


class WorkProvider {

  WorkProvider();



  static String CHECK_IF_WORK_EXISTS(int workId) {
    String sql = """
    SELECT 'WORK_CACHE' AS WORK_TABLE FROM WORK_CACHE WHERE WORK_ID = $workId
    UNION
    SELECT 'WORK' AS WORK_TABLE FROM WORK WHERE WORK_ID = $workId;""";
    return sql;
  }

  static String GET_WORK_CHAPTERS(int workId) {
    String sql = """
    SELECT CHAP_ID, CHAP_ORDER FROM CHAPTER_CACHE WHERE WORK_ID = $workId
    UNION
    SELECT CHAP_ID, CHAP_ORDER FROM CHAPTER WHERE WORK_ID = $workId
    ORDER BY CHAP_ORDER DESC;""";
    return sql;
  }

  static DBSet BUILD_INSERT_INTO_WORK(Work work, bool cache, [bool updateFetch = true]) {
    String sql = """
    INSERT INTO WORK${cache?"_CACHE":""} (WORK_ID, TITLE, AUTHOR, RATING, WARNING, CATEGORIES, FANDOMS, RELATIONSHIPS, CHARACTERS, TAGS, LANGUAGE, PUBLISHED_DATE, STATUS_LABEL, STATUS_DATE, WORDS, CHAPTER_STATS, COMMENTS, KUDOS, BOOKMARKS, HITS, SUMMARY${updateFetch?", LAST_FETCH_DATE":""})
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?${updateFetch?", CURRENT_TIMESTAMP":""});""";
    List<Object> params = [
      work.id,
      work.title,
      work.author,
      work.rating,
      work.warning,
      work.categories.join("|"),
      work.fandoms.join("|"),
      work.relationships.join("|"),
      work.characters.join("|"),
      work.addTags.join("|"),
      work.language,
      (work.publishedDate.isNotEmpty?new DateFormat(work.publishedDate.contains("-")?"y-MM-d":"d MMM y").parse(work.publishedDate).toIso8601String():""),
      work.statusLabel,
      (work.statusDate.isNotEmpty?new DateFormat(work.statusDate.contains("-")?"y-MM-d":"d MMM y").parse(work.statusDate).toIso8601String():""),
      work.words,
      work.chapterStats,
      work.comments,
      work.kudos,
      work.bookmarks,
      work.hits,
      work.summary
    ];
    return DBSet(sql, params);
  }

  static DBSet BUILD_UPDATE_INTO_WORK(Work work, bool cache, [bool updateFetch = true]) {
    String sql = """
    UPDATE WORK${cache?"_CACHE":""} SET 
      TITLE = ?, AUTHOR = ?, RATING = ?, WARNING = ?, CATEGORIES = ?, FANDOMS = ?,
      RELATIONSHIPS = ?, CHARACTERS = ?, TAGS = ?, LANGUAGE = ?, PUBLISHED_DATE = ?,
      STATUS_LABEL = ?, STATUS_DATE = ?, WORDS = ?, CHAPTER_STATS = ?, COMMENTS = ?,
      KUDOS = ?, BOOKMARKS = ?, HITS = ?, SUMMARY = ?${updateFetch?", LAST_FETCH_DATE = CURRENT_TIMESTAMP":""}
    WHERE WORK_ID = ${work.id};""";
    List<Object> params = [
      work.title,
      work.author,
      work.rating,
      work.warning,
      work.categories.join("|"),
      work.fandoms.join("|"),
      work.relationships.join("|"),
      work.characters.join("|"),
      work.addTags.join("|"),
      work.language,
      (work.publishedDate.isNotEmpty?new DateFormat(work.publishedDate.contains("-")?"y-MM-d":"d MMM y").parse(work.publishedDate).toIso8601String():""),
      work.statusLabel,
      (work.statusDate.isNotEmpty?new DateFormat(work.statusDate.contains("-")?"y-MM-d":"d MMM y").parse(work.statusDate).toIso8601String():""),
      work.words,
      work.chapterStats,
      work.comments,
      work.kudos,
      work.bookmarks,
      work.hits,
      work.summary
    ];
    return DBSet(sql, params);
  }



  Future<Map<String, Object?>> getWorkData(int workId) async {
    String table = await whichTableIsWorkIn(workId);
    if (table == "NONE") return new Map();
    Database db = await DB.instance.database;
    List<Map<String, Object?>> results = await db.rawQuery("SELECT * FROM $table WHERE WORK_ID = $workId");

    if (results.isEmpty) return new Map();
    else return results.first;
  }

  Future<String> whichTableIsWorkIn(int workId) async {
    Database db = await DB.instance.database;
    List<Map<String, Object?>> checkRes = await db.rawQuery(CHECK_IF_WORK_EXISTS(workId));
    if (checkRes.isEmpty) return "NONE";
    else return (checkRes.first.entries.first.value as String);
  }

  Future<bool> doesWorkNeedRefresh(int workId) async {
    print("checking refresh");
    Database db = await DB.instance.database;
    List<Map<String, Object?>> checkRes = await db.rawQuery(CHECK_IF_WORK_EXISTS(workId));
    if (checkRes.isNotEmpty) {
      List<Map<String, Object?>> fetchRes = await db.rawQuery("SELECT LAST_FETCH_DATE FROM ${(checkRes.first.entries.first.value as String)} WHERE WORK_ID = $workId");
      if (fetchRes.isNotEmpty && fetchRes.first["LAST_FETCH_DATE"] != null) {
        DateTime fetchDate = DateTime.parse(fetchRes.first["LAST_FETCH_DATE"] as String);

        return fetchDate.isBefore(DateTime.now().subtract(Duration(hours: 12)));
      }
    }
    return true;
  }

  Future<void> addWorkToCache(Work work, [bool updateFetch = true]) async {
    Database db = await DB.instance.database;
    List<Map<String, Object?>> checkRes = await db.rawQuery(CHECK_IF_WORK_EXISTS(work.id));
    if (checkRes.isEmpty) {
      DBSet query = BUILD_INSERT_INTO_WORK(work, true, updateFetch);
      await db.rawInsert(query.sql, query.params);
    }
    else {
      DBSet query = BUILD_UPDATE_INTO_WORK(work, (checkRes.first.entries.first.value as String) == "WORK_CACHE", updateFetch);
      await db.rawUpdate(query.sql, query.params);
    }
  }

  Future<List<Map<String, Object?>>> getWorkChaptersData(int workId) async {
    Database db = await DB.instance.database;
    return await db.rawQuery(GET_WORK_CHAPTERS(workId));
  }
}
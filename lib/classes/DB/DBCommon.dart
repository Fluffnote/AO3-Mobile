import 'package:ao3mobile/classes/Work.dart';
import 'package:intl/intl.dart';

class DBSet {
  String sql = "";
  List<Object> params = [];
  DBSet(this.sql, this.params);
}

class DBCommon {

  static const String DROP_WORK_CACHE = "DROP TABLE IF EXISTS WORK_CACHE;";
  static const String DROP_CHAPTER_CACHE = "DROP TABLE IF EXISTS CHAPTER_CACHE;";

  static String CHECK_IF_WORK_EXISTS(int workId) {
    String sql = """
    SELECT 'WORK_CACHE' AS WORK_TABLE FROM WORK_CACHE WHERE WORK_ID = \${ID}
    UNION
    SELECT 'WORK' AS WORK_TABLE FROM WORK WHERE WORK_ID = \${ID};""";
    return sql.replaceAll("\$\{ID}", workId.toString());
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

}
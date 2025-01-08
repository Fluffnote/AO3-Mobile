class DBSchema {

  static const String HISTORY_CREATE = """
    CREATE TABLE IF NOT EXISTS HISTORY(
      ID INTEGER PRIMARY KEY,
      WORK_ID INTEGER,
      WORK_NAME TEXT,
      AUTHOR TEXT,
      CHAP_ID INTEGER,
      CHAP_NAME TEXT,
      POS DOUBLE,
      MAX_POS DOUBLE
    );""";

  static const String WORK_CREATE = """
    CREATE TABLE IF NOT EXISTS WORK(
      ID INTEGER PRIMARY KEY,
      WORK_ID INTEGER,
      TITLE TEXT,
      AUTHOR TEXT,
      RATING TEXT,
      CATEGORIES TEXT,
      FANDOMS TEXT,
      TAGS TEXT,
      LANGUAGE TEXT,
      LAST_EDIT_DATE TIMESTAMP,
      CHAPTERS TEXT,
      WORDS INTEGER,
      CHAPTER_STATS TEXT,
      COMMENTS INTEGER,
      KUDOS INTEGER,
      BOOKMARKS INTEGER,
      HITS INTEGER,
      SUMMARY TEXT
    );""";

  static const String WORK_CACHE_CREATE = """
    CREATE TABLE IF NOT EXISTS WORK_CACHE(
      ID INTEGER PRIMARY KEY,
      WORK_ID INTEGER,
      TITLE TEXT,
      AUTHOR TEXT,
      RATING TEXT,
      CATEGORIES TEXT,
      FANDOMS TEXT,
      TAGS TEXT,
      LANGUAGE TEXT,
      LAST_EDIT_DATE TIMESTAMP,
      CHAPTERS TEXT,
      WORDS INTEGER,
      CHAPTER_STATS TEXT,
      COMMENTS INTEGER,
      KUDOS INTEGER,
      BOOKMARKS INTEGER,
      HITS INTEGER,
      SUMMARY TEXT
    );""";

  static const String CHAPTER_CREATE = """
    CREATE TABLE IF NOT EXISTS CHAPTER(
      ID INTEGER PRIMARY KEY,
      WORK_ID INTEGER,
      CHAP_ID INTEGER,
      CHAP_ORDER INTEGER,
      PART INTEGER,
      CHAP_ID_NEXT INTEGER,
      NUM TEXT,
      TITLE TEXT,
      SUMMARY TEXT,
      NOTES TEXT,
      BODY TEXT
    );""";

  static const String CHAPTER_CACHE_CREATE = """
    CREATE TABLE IF NOT EXISTS CHAPTER_CACHE(
      ID INTEGER PRIMARY KEY,
      WORK_ID INTEGER,
      CHAP_ID INTEGER,
      CHAP_ORDER INTEGER,
      PART INTEGER,
      CHAP_ID_NEXT INTEGER,
      NUM TEXT,
      TITLE TEXT,
      SUMMARY TEXT,
      NOTES TEXT,
      BODY TEXT
    );""";

  static const String SEARCH_RESULTS_CREATE = """
    CREATE TABLE IF NOT EXISTS SEARCH_RESULTS(
      ID INTEGER PRIMARY KEY,
      WORK_ID INTEGER
    );""";

  static const String LIBRARY_CREATE = """
    CREATE TABLE IF NOT EXISTS LIBRARY(
      ID INTEGER PRIMARY KEY,
      WORK_ID INTEGER,
      LABEL_ID INTEGER,
      DATE_ADDED TIMESTAMP
    );""";

  static const String LABELS_CREATE = """
    CREATE TABLE IF NOT EXISTS LABELS(
      ID INTEGER PRIMARY KEY,
      LABEL_NAME TEXT,
      LABEL_ORDER INTEGER
    );""";

  static const String FILTERS_CREATE = """
    CREATE TABLE IF NOT EXISTS FILTERS(
      ID INTEGER PRIMARY KEY,
      SEARCH_QUERY TEXT,
      TITLE TEXT,
      CREATORS TEXT,
      REVISED_AT TEXT,
      COMPLETE TEXT,
      CROSSOVER TEXT,
      SINGLE_CHAPTER BOOLEAN,
      WORD_COUNT TEXT,
      LANGUAGE_ID TEXT,
      FANDOM_NAMES TEXT,
      RATING_IDS TEXT,
      ARCHIVE_WARNING_IDS TEXT,
      CATEGORY_IDS TEXT,
      CHARACTER_NAMES TEXT,
      RELATIONSHIP_NAMES TEXT,
      FREEFORM_NAMES TEXT,
      HITS TEXT,
      KUDOS_COUNT TEXT,
      COMMENTS_COUNT TEXT,
      BOOKMARKS_COUNT TEXT,
      SORT_COLUMN TEXT,
      SORT_DIRECTION TEXT
    );""";

}
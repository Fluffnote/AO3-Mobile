export class UpgradePathStatements {
  upgradeStmts = [
    { toVersion: 1,
      statements: [
        `CREATE TABLE IF NOT EXISTS WORK_CACHE (
            ID INT PRIMARY KEY,
            TITLE TEXT,
            AUTHOR TEXT,
            SUMMARY TEXT,
            RATING_SYMBOL TEXT,
            RPO_SYMBOL TEXT,
            WARNING_SYMBOL TEXT,
            STATUS_SYMBOL TEXT,
            RATING TEXT,
            WARNING TEXT,
            CATEGORIES TEXT,
            FANDOMS TEXT,
            REALATIONSHIPS TEXT,
            CHARACTERS TEXT,
            FREEFORMS TEXT,
            LANGUAGE_ID TEXT,
            PUBLISHED_DATE DATETIME,
            LAST_UPDATED_DATE DATETIME,
            COMPLETE_DATE DATETIME,
            CHAPTER_STATS TEXT,
            WORDS INT,
            COMMENTS INT,
            KUDOS INT,
            BOOKMARKS INT,
            HITS INT,
            LAST_FETCHED_DATE DATETIME,
            PARSER_VERSION INT
         )`,
        `CREATE TABLE IF NOT EXISTS CHAPTER_CACHE (
            ID INT PRIMARY KEY,
            CHAPTER_ID INT,
            WORK_ID INT,
            NEXT_ID INT,
            ORDER_NUM INT,
            CHAPTER_LIST_HEADER TEXT,
            CHAPTER_HEADER TEXT,
            SUMMARY TEXT,
            NOTES TEXT,
            END_NOTES TEXT,
            BODY TEXT,
            LAST_FETCHED_DATE DATETIME,
            PARSER_VERSION INT
         )`,
        `CREATE TABLE IF NOT EXISTS HISTORY (
            ID INT PRIMARY KEY,
            WORK_ID INT,
            CHAPTER_ID INT,
            WORK_TITLE TEXT,
            AUTHOR TEXT,
            CHAPTER_HEADER TEXT,
            SCROLL_POSITION DOUBLE,
            SCROLL_MAX DOUBLE,
            ACCESS_DATE DATETIME
         )`,
      ]
    }
  ]
}


class SearchQueryParameters {
  // Static query maps
  static final Map<String, String> completionStatusOptions = {
    "":"All works",
    "T":"Complete works only",
    "F":"Works in progress only",
  };

  static final Map<String, String> crossoversOptions = {
    "":"Include crossovers",
    "F":"Exclude crossovers",
    "T":"Only crossovers",
  };

  static final Map<String, String> languageOptions = {
    "":"Any",
  };

  static final Map<String, String> sortColumnOptions = {
    "_score":"Best Match",
    "authors_to_sort_on":"Author",
    "title_to_sort_on":"Title",
    "created_at":"Date Posted",
    "revised_at":"Date Updated",
    "word_count":"Word Count",
    "hits":"Hits",
    "kudos_count":"Kudos",
    "comments_count":"Comments",
    "bookmarks_count":"Bookmarks",
  };

  static final Map<String, String> sortDirectionOptions = {
    "asc":"Ascending",
    "desc":"Descending",
  };



  // Work Info
  String query = '';
  String title = '';
  String creators = '';
  String revisedAt = '';
  String complete = '';
  String crossover = '';
  bool singleChapter = false;
  String wordCount = "";
  String languageId = '';

  // Work Tags
  List<String> fandomNames = [];
  String ratingIds = '';
  List<String> archiveWarningIds = [];
  List<String> categoryIds = [];
  List<String> characterNames = [];
  List<String> relationshipNames = [];
  List<String> freeformNames = [];

  // Work Stats
  String hits = '';
  String kudosCount = '';
  String commentsCount = '';
  String bookmarksCount = '';

  // Search
  String sortColumn = '_score';
  String sortDirection = 'desc';
  int page = 1;

  SearchQueryParameters({

    this.query = "",
    this.title = "",
    this.creators = "",
    this.revisedAt = "",
    this.complete = "",
    this.crossover = "",
    this.singleChapter = false,
    this.wordCount = "",
    this.languageId = "",
    this.fandomNames = const [],
    this.ratingIds = "",
    this.archiveWarningIds = const [],
    this.categoryIds = const [],
    this.characterNames = const [],
    this.relationshipNames = const [],
    this.freeformNames = const [],
    this.hits = "",
    this.kudosCount = "",
    this.commentsCount = "",
    this.bookmarksCount = "",
    this.sortColumn = "_score",
    this.sortDirection = "desc",
    this.page = 1,
  });

  Map<String, dynamic> getParams() {

    Map<String, dynamic> out = {};

    // Adding work info
    out.addAll({
      'work_search[query]':query,
      'work_search[title]':title,
      'work_search[creators]':creators,
      'work_search[revised_at]':revisedAt,
      'work_search[complete]':complete,
      'work_search[crossover]':crossover,
      'work_search[single_chapter]':singleChapter?'1':'0',
      'work_search[word_count]':wordCount,
      'work_search[language_id]':languageId,
    });

    // Adding work tags
    String FNF = "";
    for (String item in fandomNames) {
      if (item.isEmpty) continue;
      if (FNF.isEmpty) { FNF = item; }
      else { FNF += ",$item"; }
    }
    out.addAll({
      'work_search[fandom_names]': FNF,
      'work_search[rating_ids]':'',
      'work_search[archive_warning_ids][]':'',
      'work_search[category_ids][]':'',
      'work_search[character_names]':'',
      'work_search[relationship_names]':'',
      'work_search[freeform_names]':'',
    });

    // Adding work stats
    out.addAll({
      'work_search[hits]':hits,
      'work_search[kudos_count]':kudosCount,
      'work_search[comments_count]':commentsCount,
      'work_search[bookmarks_count]':bookmarksCount,
    });

    // Adding search options
    out.addAll({
      'work_search[sort_column]':sortColumn,
      'work_search[sort_direction]':sortDirection,
      'commit':'Search',
      'page':'$page',
    });

    return out;
  }
}
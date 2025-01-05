import 'package:ao3mobile/classes/Work.dart';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

// Static query maps
final Map<String, String> completionStatusOptions = {
  "":"All works",
  "T":"Complete works only",
  "F":"Works in progress only",
};

final Map<String, String> crossoversOptions = {
  "":"Include crossovers",
  "F":"Exclude crossovers",
  "T":"Only crossovers",
};

final Map<String, String> languageOptions = {
  "":"Any",
};

final Map<String, String> sortColumnOptions = {
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

final Map<String, String> sortDirectionOptions = {
  "asc":"Ascending",
  "desc":"Descending",
};



// Main
class WorkSearchQueryParameters {
  // Work Info
  String query = '';
  String title = '';
  String creators = '';
  String revisedAt = '';
  String complete = '';
  String crossover = '';
  bool singleChapter = false;
  int wordCount = -1;
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

  WorkSearchQueryParameters({

    this.query = "",
    this.title = "",
    this.creators = "",
    this.revisedAt = "",
    this.complete = "",
    this.crossover = "",
    this.singleChapter = false,
    this.wordCount = -1,
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
      'work_search[word_count]':(wordCount != -1)?'$wordCount':'',
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
      'work_search[hits]':'',
      'work_search[kudos_count]':'',
      'work_search[comments_count]':'',
      'work_search[bookmarks_count]':'',
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

class SearchData {

  String numFound = "";
  List<PartialWork> works = [];

  SearchData({
    this.numFound = "",
    this.works = const []
  });
}

Future<SearchData> workSearch(WorkSearchQueryParameters params) async {

  Uri httpsSearch = Uri(
      scheme: 'https',
      host: 'archiveofourown.org',
      path: 'works/search',
      queryParameters: params.getParams()
  );

  if (kDebugMode) {
    print("Search started: $httpsSearch");
  }
  dom.Document page = parse((await http.get(httpsSearch)).body);
  // Can't find any results
  if (page.getElementsByClassName("work index group").isEmpty) return SearchData();
  List<PartialWork> out = [];
  String numFound = "";

  String numFoundRaw = page.getElementById("main")?.children.elementAt(4).text ?? "";
  numFound = (numFoundRaw.isNotEmpty)?numFoundRaw.substring(0, numFoundRaw.indexOf("Found")+5):"";

  for(dom.Element elem in page.getElementsByClassName("work index group").first.children) {
    out.add(PartialWork.create(elem));
  }

  return SearchData(numFound:numFound, works: out);
}
import 'dart:core';

import '../../layout/ui/core/AO3Symbols.dart';
import 'Chapter.dart';



class Work {

  Work();

  DateTime lastFetchDate = DateTime.now();

  int id = -1;
  String title = "";
  String author = "";

  ContentRating ratingSymbol = ContentRating.None;
  RPO RPOSymbol = RPO.None;
  ContentWarning warningSymbol = ContentWarning.None;
  Status statusSymbol = Status.Unknown;

  String rating = "";
  String warning = "";
  List<String> categories = [];
  List<String> fandoms = [];
  List<String> relationships = [];
  List<String> characters = [];
  List<String> addTags = [];
  String language = "";

  // Stats
  String publishedDate = "";
  String statusLabel = "";
  String statusDate = "";
  int words = 0;
  String chapterStats = "";
  int comments = 0;
  int kudos = 0;
  int bookmarks = 0;
  int hits = 0;

  String summary = "";

  List<ChapterKey> chapters = [];

  Map<String, dynamic> toMap() {

    List<Map<String, dynamic>> cc = [];

    for(ChapterKey ck in chapters) {
      cc.add(ck.toMap());
    }

    Map<String, dynamic> temp = {
      "lastFetchDate": lastFetchDate.toIso8601String(),

      "id": id,
      "title": title,
      "author": author,

      "ratingSymbol": ratingSymbol.index,
      "RPOSymbol": RPOSymbol.index,
      "warningSymbol": warningSymbol.index,
      "statusSymbol": statusSymbol.index,

      "rating": rating,
      "warning": warning,

      "categories": categories,
      "fandoms": fandoms,
      "relationships": relationships,
      "characters": characters,
      "addTags": addTags,

      "language": language,

      "publishedDate": publishedDate,
      "statusLabel": statusLabel,
      "statusDate": statusDate,
      "words": words,
      "chapterStats": chapterStats,
      "comments": comments,
      "kudos": kudos,
      "bookmarks": bookmarks,
      "hits": hits,

      "summary": summary,

      "chapters": cc
    };

    return temp;
  }
}


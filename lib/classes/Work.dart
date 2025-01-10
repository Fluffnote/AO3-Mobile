import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:html2md/html2md.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Chapter.dart';
import 'DB/DB.dart';
import 'DB/DBCommon.dart';




// Work functions

/// Gets Work object
///
/// [refreshType] = 0 : Doesn't refresh - Only grabs database info
///
/// [refreshType] = 1 : Soft refresh - Will attempt to refresh info if it has been more than 30 min from last fetch
///
/// [refreshType] = 2 : Hard refresh - Will attempt to refresh info regardless of last fetch
Future<Work> getWork(int workId, [int refreshType = 0]) async {
  String table = await whichTableIsWorkIn(workId);
  if (table == "NONE" || refreshType == 2 || (refreshType == 1 && await doesWorkNeedRefresh(workId))) {
    http.Response response;
    final client = RetryClient(http.Client());
    try {
      response = await client.get(Uri.parse("https://archiveofourown.org/works/$workId?view_adult=true"));
      Work.createWork(parse(response.body), workId);
    }
    finally {
      client.close();
    }
  }

  table = await whichTableIsWorkIn(workId);
  if (table == "NONE") return getWork(workId, refreshType);
  Database db = await DB.instance.database;
  List<Map<String, Object?>> results = await db.rawQuery("SELECT * FROM $table WHERE WORK_ID = $workId");

  return Work.parseResults(results);
}

class Work {

  int id = -1;
  String title = "";
  String author = "";

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

  List<Chapter> chapters = [];



  Work();



  factory Work.createWork(dom.Document page, int workId) {
    Work temp = Work();
    if (!page.hasContent()) return temp;



    temp.id = workId;
    if (page.body!.getElementsByClassName("title heading").isNotEmpty) {
      temp.title = page.body!.getElementsByClassName("title heading").first.text.trim();
    }
    if (page.body!.getElementsByClassName("byline heading").isNotEmpty) {
      temp.author = page.body!.getElementsByClassName("byline heading").first.text.trim();
    }



    // Getting work info
    temp.rating = page.getElementsByClassName("rating tags").last.children.first.children.first.text; // Adding rating
    temp.warning = page.getElementsByClassName("warning tags").last.children.first.children.first.text; // Adding warning
    if (page.getElementsByClassName("category tags").isNotEmpty) { // Adding categories
      for(dom.Element elem in page.getElementsByClassName("category tags").last.children.first.children) {
        temp.categories.add(elem.children.first.text);
      }
    }
    if (page.getElementsByClassName("fandom tags").isNotEmpty) { // Adding fandoms
      for(dom.Element elem in page.getElementsByClassName("fandom tags").last.children.first.children) {
        temp.fandoms.add(elem.children.first.text);
      }
    }
    if (page.getElementsByClassName("relationship tags").isNotEmpty) { // Adding relationships
      for(dom.Element elem in page.getElementsByClassName("relationship tags").last.children.first.children) {
        temp.relationships.add(elem.children.first.text);
      }
    }
    if (page.getElementsByClassName("character tags").isNotEmpty) { // Adding characters
      for(dom.Element elem in page.getElementsByClassName("character tags").last.children.first.children) {
        temp.characters.add(elem.children.first.text);
      }
    }
    if (page.getElementsByClassName("freeform tags").isNotEmpty) { // Adding additional tags
      for(dom.Element elem in page.getElementsByClassName("freeform tags").last.children.first.children) {
        temp.addTags.add(elem.text);
      }
    }
    temp.language = page.getElementsByClassName("language").last.text.replaceAll("\n", "").trim(); // Adding language



    // Getting stats
    dom.Element stats = page.getElementsByClassName("stats").last;
    temp.publishedDate = stats.getElementsByClassName("published").last.text;
    if (stats.getElementsByClassName("status").isNotEmpty) {
      temp.statusLabel = stats.getElementsByClassName("status").first.text.replaceFirst(":", "");
      temp.statusDate = stats.getElementsByClassName("status").last.text;
    }
    if (stats.getElementsByClassName("words").isNotEmpty) { // Getting word count
      String tempWords = stats.getElementsByClassName("words").last.text;
      temp.words = tempWords.isNotEmpty?int.parse(tempWords.replaceAll(RegExp(r"[^0-9]"), "")):0;
    }
    if (stats.getElementsByClassName("chapters").isNotEmpty) temp.chapterStats = stats.getElementsByClassName("chapters").last.text;
    if (stats.getElementsByClassName("comments").isNotEmpty) { // Getting comments count
      String tempComments = stats.getElementsByClassName("comments").last.text;
      temp.comments = tempComments.isNotEmpty?int.parse(tempComments.replaceAll(RegExp(r"[^0-9]"), "")):0;
    }
    if (stats.getElementsByClassName("kudos").isNotEmpty) { // Getting kudos count
      String tempKudos = stats.getElementsByClassName("kudos").last.text;
      temp.kudos = tempKudos.isNotEmpty?int.parse(tempKudos.replaceAll(RegExp(r"[^0-9]"), "")):0;
    }
    if (stats.getElementsByClassName("bookmarks").isNotEmpty) { // Getting bookmarks count
      String tempBookmarks = stats.getElementsByClassName("bookmarks").last.text;
      temp.bookmarks = tempBookmarks.isNotEmpty?int.parse(tempBookmarks.replaceAll(RegExp(r"[^0-9]"), "")):0;
    }
    if (stats.getElementsByClassName("hits").isNotEmpty) { // Getting hits count
      String tempHits = stats.getElementsByClassName("hits").last.text;
      temp.hits = tempHits.isNotEmpty?int.parse(tempHits.replaceAll(RegExp(r"[^0-9]"), "")):0;
    }



    // Adding chapter info
    if (page.getElementById("chapter_index") != null) {
      for (dom.Element elem in page
          .getElementById("chapter_index")!
          .children
          .first
          .children
          .first
          .children
          .first
          .children
          .first
          .children) {
        if (elem.outerHtml.contains('<span class="submit actions">')) continue;
        String tempIDClipping = elem.outerHtml.substring(
            elem.outerHtml.indexOf('value="') + 7);
        temp.chapters.add(Chapter.create(
            workId: workId,
            id: int.parse(
                tempIDClipping.substring(0, tempIDClipping.indexOf('"'))),
            title: tempIDClipping.substring(
                tempIDClipping.indexOf(".") + 2, tempIDClipping.indexOf("<")),
            num: tempIDClipping.substring(
                tempIDClipping.indexOf(">") + 1, tempIDClipping.indexOf("."))
        ));
      }
    }
    else {
      temp.chapters.add(Chapter.create(
          workId: workId,
          id: -1,
          title: page.getElementsByClassName("title heading").first.text.replaceAll("\n", "").trim(),
          num: "1"
      )
      );
    }



    // Getting first summary
    if (page.getElementsByClassName("summary module").isNotEmpty) temp.summary = convert(page.getElementsByClassName("summary module").first.getElementsByClassName("userstuff").first.innerHtml);



    addWorkToCache(temp);
    return temp;
  }



  factory Work.createPartial(dom.Element part) {
    Work temp = Work();
    if (!part.hasContent()) return temp;

    temp.id = int.parse(part.id.replaceAll("work_", ""));

    dom.Element header = part.getElementsByClassName("header module").first;
    temp.title = header.children.first.children.first.text;
    temp.author = header.children.first.children.last.text;



    for(dom.Element fandomElem in header.getElementsByClassName("fandoms heading").first.children) {
      if (fandomElem.text.trim() == "Fandoms:") continue;
      temp.fandoms.add(fandomElem.text);
    }

    if (part.getElementsByClassName("tags commas").isNotEmpty) {
      dom.Element tags = part.getElementsByClassName("tags commas").first;

      for(dom.Element tagElem in tags.children) {
        temp.addTags.add(tagElem.text);
      }
    }



    dom.Element stats = part.getElementsByClassName("stats").first;
    temp.statusDate = header.getElementsByClassName("datetime").first.text;
    if (stats.getElementsByClassName("language").isNotEmpty) temp.language = stats.getElementsByClassName("language").last.text;
    if (stats.getElementsByClassName("chapters").isNotEmpty) temp.chapterStats = stats.getElementsByClassName("chapters").last.text;
    if (stats.getElementsByClassName("words").isNotEmpty) { // Getting word count
      String tempWords = stats.getElementsByClassName("words").last.text;
      temp.words = tempWords.isNotEmpty?int.parse(tempWords.replaceAll(RegExp(r"[^0-9]"), "")):0;
    }
    if (stats.getElementsByClassName("comments").isNotEmpty) { // Getting comments count
      String tempComments = stats.getElementsByClassName("comments").last.text;
      temp.comments = tempComments.isNotEmpty?int.parse(tempComments.replaceAll(RegExp(r"[^0-9]"), "")):0;
    }
    if (stats.getElementsByClassName("kudos").isNotEmpty) { // Getting kudos count
      String tempKudos = stats.getElementsByClassName("kudos").last.text;
      temp.kudos = tempKudos.isNotEmpty?int.parse(tempKudos.replaceAll(RegExp(r"[^0-9]"), "")):0;
    }



    if (part.getElementsByClassName("userstuff summary").isNotEmpty) {
      temp.summary = convert(part.getElementsByClassName("userstuff summary").first.innerHtml);
    }



    addWorkToCache(temp, false);
    return temp;
  }



  factory Work.parseResults(List<Map<String, Object?>> results) {
    Work temp = Work();

    temp.id = results.first["WORK_ID"] as int;
    temp.title = results.first["TITLE"] as String;
    temp.author = results.first["AUTHOR"] as String;

    temp.rating = results.first["RATING"] as String;
    temp.warning = results.first["WARNING"] as String;
    temp.categories = (results.first["CATEGORIES"] as String).split("|");
    temp.fandoms = (results.first["FANDOMS"] as String).split("|");
    temp.relationships = (results.first["RELATIONSHIPS"] as String).split("|");
    temp.characters = (results.first["CHARACTERS"] as String).split("|");
    temp.addTags = (results.first["TAGS"] as String).split("|");
    temp.language = results.first["LANGUAGE"] as String;

    // Stats
    temp.publishedDate = results.first["PUBLISHED_DATE"]!=null&&(results.first["PUBLISHED_DATE"] as String).isNotEmpty?DateFormat.yMMMd('en_US').format(DateTime.parse(results.first["PUBLISHED_DATE"] as String)):"";
    temp.statusLabel = results.first["STATUS_LABEL"] as String;
    temp.statusDate = results.first["STATUS_DATE"]!=null&&(results.first["STATUS_DATE"] as String).isNotEmpty?DateFormat.yMMMd('en_US').format(DateTime.parse(results.first["STATUS_DATE"] as String)):"";
    temp.words = results.first["WORDS"] as int;
    temp.chapterStats = results.first["CHAPTER_STATS"] as String;
    temp.comments = results.first["COMMENTS"] as int;
    temp.kudos = results.first["KUDOS"] as int;
    temp.bookmarks = results.first["BOOKMARKS"] as int;
    temp.hits = results.first["HITS"] as int;

    temp.summary = results.first["SUMMARY"] as String;

    return temp;
  }
}

Future<void> openWorkPage(int work) async {
  Uri uri =  Uri.parse("https://archiveofourown.org/works/$work?view_adult=true");
  if (!await launchUrl(uri)) throw Exception('Could not launch $uri');
}

Future<String> whichTableIsWorkIn(int workId) async {
  Database db = await DB.instance.database;
  List<Map<String, Object?>> checkRes = await db.rawQuery(DBCommon.CHECK_IF_WORK_EXISTS(workId));
  if (checkRes.isEmpty) return "NONE";
  else return (checkRes.first.entries.first.value as String);
}

Future<bool> doesWorkNeedRefresh(int workId) async {
  Database db = await DB.instance.database;
  List<Map<String, Object?>> checkRes = await db.rawQuery(DBCommon.CHECK_IF_WORK_EXISTS(workId));
  if (checkRes.isNotEmpty) {
    List<Map<String, Object?>> fetchRes = await db.rawQuery("SELECT LAST_FETCH_DATE FROM ${(checkRes.first.entries.first.value as String)} WHERE WORK_ID = $workId");
    if (fetchRes.isNotEmpty && fetchRes.first["LAST_FETCH_DATE"] != null) {
      DateTime fetchDate = DateTime.parse(fetchRes.first["LAST_FETCH_DATE"] as String);

      return fetchDate.isBefore(DateTime.now().subtract(Duration(minutes: 30)));
    }
  }
  return true;
}

Future<void> addWorkToCache(Work work, [bool updateFetch = true]) async {
  Database db = await DB.instance.database;
  List<Map<String, Object?>> checkRes = await db.rawQuery(DBCommon.CHECK_IF_WORK_EXISTS(work.id));
  if (checkRes.isEmpty) {
    DBSet query = DBCommon.BUILD_INSERT_INTO_WORK(work, true, updateFetch);
    await db.rawInsert(query.sql, query.params);
  }
  else {
    DBSet query = DBCommon.BUILD_UPDATE_INTO_WORK(work, (checkRes.first.entries.first.value as String) == "WORK_CACHE", updateFetch);
    await db.rawUpdate(query.sql, query.params);
  }
}


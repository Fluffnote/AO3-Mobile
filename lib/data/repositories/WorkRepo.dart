import 'package:ao3mobile/data/providers/A03Provider.dart';
import 'package:ao3mobile/data/providers/HistoryProvider.dart';
import 'package:ao3mobile/data/providers/WorkProvider.dart';
import 'package:ao3mobile/data/repositories/ChapterRepo.dart';
import 'package:html/dom.dart' as dom;
import 'package:html2md/html2md.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/Chapter.dart';
import '../models/History.dart';
import '../models/Work.dart';

class WorkRepo {

  WorkRepo();

  // Repos
  final ChapterRepo chapterRepo = new ChapterRepo();

  // Providers
  final AO3Provider ao3provider = new AO3Provider();
  final WorkProvider workProvider = new WorkProvider();
  final HistoryProvider historyProvider = new HistoryProvider();



  /// Gets Work object
  ///
  /// [refreshType] = 0 : Doesn't refresh - Only grabs database info
  ///
  /// [refreshType] = 1 : Soft refresh - Will attempt to refresh info if it has been more than 30 min from last fetch
  ///
  /// [refreshType] = 2 : Hard refresh - Will attempt to refresh info regardless of last fetch
  ///
  Future<Work> getWork(int workId, [int refreshType = 0, bool getChapters = true]) async {
    String table = await workProvider.whichTableIsWorkIn(workId);
    if (table == "NONE" || refreshType >= 2 || (refreshType == 1 && await workProvider.doesWorkNeedRefresh(workId))) {
      await parseRawPage(await ao3provider.getRawWork(workId), workId);
    }


    Map<String, Object?> workData = await workProvider.getWorkData(workId);
    if (workData.isEmpty) getWork(workId, refreshType+1); // Catching for failed caching
    Work temp = parseTableResult(workData);

    if (getChapters) temp.chapters = await getWorkChapters(temp.id);

    return temp;
  }



  // Table parsing
  Work parseTableResult(Map<String, Object?> map) {
    Work temp = Work();

    temp.id = map["WORK_ID"] as int;
    temp.title = map["TITLE"] as String;
    temp.author = map["AUTHOR"] as String;

    temp.rating = map["RATING"] as String;
    temp.warning = map["WARNING"] as String;
    temp.categories = (map["CATEGORIES"] as String).split("|");
    temp.fandoms = (map["FANDOMS"] as String).split("|");
    temp.relationships = (map["RELATIONSHIPS"] as String).split("|");
    temp.characters = (map["CHARACTERS"] as String).split("|");
    temp.addTags = (map["TAGS"] as String).split("|");
    temp.language = map["LANGUAGE"] as String;

    // Stats
    temp.publishedDate = map["PUBLISHED_DATE"]!=null&&(map["PUBLISHED_DATE"] as String).isNotEmpty?DateFormat.yMMMd('en_US').format(DateTime.parse(map["PUBLISHED_DATE"] as String)):"";
    temp.statusLabel = map["STATUS_LABEL"] as String;
    temp.statusDate = map["STATUS_DATE"]!=null&&(map["STATUS_DATE"] as String).isNotEmpty?DateFormat.yMMMd('en_US').format(DateTime.parse(map["STATUS_DATE"] as String)):"";
    temp.words = map["WORDS"] as int;
    temp.chapterStats = map["CHAPTER_STATS"] as String;
    temp.comments = map["COMMENTS"] as int;
    temp.kudos = map["KUDOS"] as int;
    temp.bookmarks = map["BOOKMARKS"] as int;
    temp.hits = map["HITS"] as int;

    temp.summary = map["SUMMARY"] as String;

    return temp;
  }



  // AO3 Document parsing
  Future<Work> parseRawPage(dom.Document page, int workId) async {
    Work temp = new Work();

    if (!page.hasContent()) return temp;

    temp.id = workId;
    if (page.getElementsByClassName("title heading").isNotEmpty) {
      temp.title = page.getElementsByClassName("title heading").first.text.trim();
    }
    if (page.getElementsByClassName("byline heading").isNotEmpty) {
      temp.author = page.getElementsByClassName("byline heading").first.text.trim();
    }


    // Getting work info
    if (page.getElementsByClassName("rating tags").isNotEmpty) { // Adding rating
      temp.rating = page.getElementsByClassName("rating tags").last.children.first.children.first.text;
    }
    if (page.getElementsByClassName("warning tags").isNotEmpty) { // Adding warning
      temp.warning = page.getElementsByClassName("warning tags").last.children.first.children.first.text;
    }
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
    if (page.getElementsByClassName("language").isNotEmpty) { // Adding language
      temp.language = page.getElementsByClassName("language").last.text.replaceAll("\n", "").trim();
    }


    // Getting stats
    if (page.getElementsByClassName("stats").isNotEmpty) {
      dom.Element stats = page.getElementsByClassName("stats").last;
      if (stats.getElementsByClassName("published").isNotEmpty) {
        temp.publishedDate = stats.getElementsByClassName("published").last.text;
      }
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
    }


    // Adding chapter info
    if (page.getElementById("chapter_index") != null) {
      page.getElementById("chapter_index")!.children.first.children.first.children.first.children.first.children
          .asMap().forEach((index, elem) {
        if (!elem.outerHtml.contains('<span class="submit actions">')) {
          String tempIDClipping = elem.outerHtml.substring(elem.outerHtml.indexOf('value="') + 7);
          temp.chapters.add(chapterRepo.createPartialChapter(
              workId,
              int.parse(tempIDClipping.substring(0, tempIDClipping.indexOf('"'))),
              tempIDClipping.substring(tempIDClipping.indexOf(".") + 2, tempIDClipping.indexOf("<")),
              tempIDClipping.substring(tempIDClipping.indexOf(">") + 1, tempIDClipping.indexOf(".")),
              index+1
          ));
        }
      });
    }
    else {
      if (page.getElementsByClassName("title heading").isNotEmpty) {
        temp.chapters.add(chapterRepo.createPartialChapter(
          workId,
          -1,
          page.getElementsByClassName("title heading").first.text.replaceAll("\n", "").trim(),
          "1",
          1
        ));
      }
    }


    // Getting first summary
    if (page.getElementsByClassName("summary module").isNotEmpty) temp.summary = convert(page.getElementsByClassName("summary module").first.getElementsByClassName("userstuff").first.innerHtml);



    workProvider.addWorkToCache(temp, true);

    return temp;
  }

  Future<Work> parseRawSearchPart(dom.Element part) async {
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



    workProvider.addWorkToCache(temp, false);

    return temp;
  }



  // Additional functions

  Future<void> openWorkPage(int work) async {
    Uri uri =  Uri.parse("https://archiveofourown.org/works/$work?view_adult=true");
    if (!await launchUrl(uri)) throw Exception('Could not launch $uri');
  }

  Future<void> openHTML(int work) async => ao3provider.openRawWorkHTML(work);


  Future<List<Chapter>> getWorkChapters(int workId) async {
    List<Chapter> out = [];
    List<Map<String, Object?>> chapterRes = await workProvider.getWorkChaptersData(workId);
    if (chapterRes.isNotEmpty) {
      for (Map<String, Object?> chap in chapterRes) {
        out.add(await chapterRepo.getChapter(workId, (chap["CHAP_ID"] as int), 0));
      }
    }

    return out;
  }

  Future<List<History>> getHistoryList() async {
    List<History> out = [];

    for (Map<String, Object?> history in await historyProvider.getHistoryListData()) {
      out.add(History.parse(history));
    }

    return out;
  }

  Future<void> deleteHistory(int workId) async {
    await historyProvider.deleteHistory(workId);
  }
}
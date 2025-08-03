import 'package:ao3mobile/data/models/Chapter.dart';
import 'package:ao3mobile/data/providers/AO3_P.dart';
import 'package:ao3mobile/data/providers/Work_P.dart';
import 'package:ao3mobile/data/repositories/ChapterRepo.dart';
import 'package:ao3mobile/layout/ui/core/AO3Symbols.dart';
import 'package:html/dom.dart' as dom;
import 'package:html2md/html2md.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/History.dart';
import '../models/Work.dart';
import '../providers/History_P.dart';

class WorkRepo {

  WorkRepo();

  // Repos
  final ChapterRepo chapterRepo = ChapterRepo();

  // Providers
  final AO3_P ao3_P = AO3_P();
  final Work_P work_P = Work_P();
  final History_P history_P = History_P();



  /// Gets Work object
  ///
  /// [refreshType] = 0 : Doesn't refresh - Only grabs database info
  ///
  /// [refreshType] = 1 : Soft refresh - Will attempt to refresh info if it has been more than 30 min from last fetch
  ///
  /// [refreshType] = 2 : Hard refresh - Will attempt to refresh info regardless of last fetch
  ///
  Future<Work> getWork(int workId, [int refreshType = 0]) async {
    Work temp = Work();
    String db = await work_P.getWorkDB(workId);
    if (db == "NONE" || refreshType >= 2 || (refreshType == 1 && await work_P.doesWorkNeedRefresh(workId, db))) {
      temp = await parseRawPage(await ao3_P.getRawWork(workId), workId);
      db = await work_P.getWorkDB(workId);
    }
    else {
      if (db == "LIBRARY") temp = await work_P.getWorkLibrary(workId);
      if (db == "TEMP") temp = await work_P.getWorkTemp(workId);
    }

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
          ChapterKey chapterKey = ChapterKey();

          chapterKey.workId = workId;
          chapterKey.id = int.parse(tempIDClipping.substring(0, tempIDClipping.indexOf('"')));

          chapterKey.title = tempIDClipping.substring(tempIDClipping.indexOf(".") + 2, tempIDClipping.indexOf("<"));
          chapterKey.num = tempIDClipping.substring(tempIDClipping.indexOf(">") + 1, tempIDClipping.indexOf("."));

          chapterKey.order = index + 1;
          chapterKey.workTitle = temp.title;

          temp.chapters.add(chapterKey);
        }
      });
    }
    else {
      if (page.getElementsByClassName("title heading").isNotEmpty) {
        ChapterKey chapterKey = ChapterKey();

        chapterKey.workId = workId;
        chapterKey.num = "1";
        chapterKey.title = page.getElementsByClassName("title heading").first.text.replaceAll("\n", "").trim();
        chapterKey.workTitle = temp.title;

        temp.chapters.add(chapterKey);
      }
    }


    // Getting first summary
    if (page.getElementsByClassName("summary module").isNotEmpty) temp.summary = convert(page.getElementsByClassName("summary module").first.getElementsByClassName("userstuff").first.innerHtml, styleOptions: {"hr":"- - -", "emDelimiter":"*", "bulletListMarker":"-"});



    work_P.pushWork(temp);

    return temp;
  }

  Future<Work> parseRawSearchPart(dom.Element part) async {
    Work temp = Work();
    if (!part.hasContent()) return temp;

    temp.id = int.parse(part.id.replaceAll("work_", ""));

    dom.Element header = part.getElementsByClassName("header module").first;
    temp.title = header.children.first.children.first.text;
    temp.author = header.children.first.children.last.text;

    if (part.getElementsByClassName("required-tags").isNotEmpty) {
      dom.Element symbolsParent = part.getElementsByClassName("required-tags").first;

      String rating = symbolsParent.getElementsByClassName("rating").first.text;
      if (rating == "Not Rated") temp.ratingSymbol = ContentRating.None;
      if (rating == "General Audiences") temp.ratingSymbol = ContentRating.General;
      if (rating == "Teen And Up Audiences") temp.ratingSymbol = ContentRating.Teen;
      if (rating == "Mature") temp.ratingSymbol = ContentRating.Mature;
      if (rating == "Explicit") temp.ratingSymbol = ContentRating.Explicit;

      String rpo = symbolsParent.getElementsByClassName("category").first.text;
      if (rpo.contains("No category")) temp.RPOSymbol = RPO.None;
      if (rpo.contains("F/F")) temp.RPOSymbol = RPO.FF;
      if (rpo.contains("M/M")) temp.RPOSymbol = RPO.MM;
      if (rpo.contains("F/M")) temp.RPOSymbol = RPO.FM;
      if (rpo.contains("Gen")) temp.RPOSymbol = RPO.Gen;
      if (rpo.contains("Other")) temp.RPOSymbol = RPO.Other;
      if (rpo.contains("Multi")) temp.RPOSymbol = RPO.Multi;

      String warning = symbolsParent.getElementsByClassName("warnings").first.text;
      if (warning.contains("No Archive Warnings Apply")) temp.warningSymbol = ContentWarning.None;
      if (warning.contains("Choose Not To Use Archive Warnings")) temp.warningSymbol = ContentWarning.Unspecified;
      if (warning.contains("External")) temp.warningSymbol = ContentWarning.External;
      if (warning.contains("Graphic Depictions Of Violence")) temp.warningSymbol = ContentWarning.Explicit;
      if (warning.contains("Major Character Death")) temp.warningSymbol = ContentWarning.Explicit;
      if (warning.contains("Rape/Non-Con")) temp.warningSymbol = ContentWarning.Explicit;
      if (warning.contains("Underage Sex")) temp.warningSymbol = ContentWarning.Explicit;

      String status = symbolsParent.getElementsByClassName("iswip").first.text;
      if (status.contains("Work in Progress")) temp.statusSymbol = Status.InProgress;
      if (status.contains("Complete Work")) temp.statusSymbol = Status.Completed;
    }



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
    if (stats.getElementsByClassName("hits").isNotEmpty) { // Getting hit count
      String tempHits = stats.getElementsByClassName("hits").last.text;
      temp.hits = tempHits.isNotEmpty?int.parse(tempHits.replaceAll(RegExp(r"[^0-9]"), "")):0;
    }



    if (part.getElementsByClassName("userstuff summary").isNotEmpty) {
      temp.summary = convert(part.getElementsByClassName("userstuff summary").first.innerHtml, styleOptions: {"hr":"- - -", "emDelimiter":"*", "bulletListMarker":"-"});
    }



    work_P.pushWork(temp);

    return temp;
  }



  // Additional functions

  Future<void> openWorkPage(int work) async {
    Uri uri =  Uri.parse("https://archiveofourown.org/works/$work?view_adult=true");
    if (!await launchUrl(uri)) throw Exception('Could not launch $uri');
  }

  Future<void> openHTML(int work) async => ao3_P.openRawWorkHTML(work);

  Future<List<History>> getHistoryList() async {
    return await history_P.getHistoryList();
  }

  Future<void> deleteHistory(int workId) async {
    // await historyProvider.deleteHistory(workId);
  }
}
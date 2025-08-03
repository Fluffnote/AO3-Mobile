import 'package:ao3mobile/data/models/History.dart';
import 'package:ao3mobile/data/repositories/WorkRepo.dart';
import 'package:html/dom.dart' as dom;
import 'package:html2md/html2md.dart';

import '../models/Chapter.dart';
import '../models/Work.dart';
import '../providers/AO3_P.dart';
import '../providers/Chapter_P.dart';
import '../providers/History_P.dart';

class ChapterRepo {

  ChapterRepo();

  // Providers
  final AO3_P ao3_P = AO3_P();
  final Chapter_P chapter_P = Chapter_P();
  final History_P history_P = History_P();

  /// Gets Chapter object
  ///
  /// [refreshType] = 0 : Doesn't refresh - Only grabs database info
  ///
  /// [refreshType] = 1 : Soft refresh - Will attempt to refresh info if it has been more than 30 min from last fetch
  ///
  /// [refreshType] = 2 : Hard refresh - Will attempt to refresh info regardless of last fetch
  Future<Chapter> getChapter(int workId, int chapterId, [int refreshType = 0]) async {
    Chapter temp = Chapter();
    String db = await chapter_P.getChapterDB(workId, chapterId);

    // Need to optimize
    if (db == "NONE" || refreshType == 2 || (refreshType == 1 && await chapter_P.doesChapterNeedRefresh(workId, chapterId, db))) {
      if (db == "NONE") WorkRepo().getWork(workId, 1);

      temp = await parseRawPage(await ao3_P.getRawChapter(workId, chapterId), workId, chapterId);
      db = await chapter_P.getChapterDB(workId, chapterId);
    }
    else {
      if (db == "LIBRARY") temp = await chapter_P.getChapterLibrary(workId, chapterId);
      if (db == "TEMP") temp = await chapter_P.getChapterTemp(workId, chapterId);
    }

    return temp;
  }



  // AO3 Document parsing
  Future<Chapter> parseRawPage(dom.Document page, int workId, int chapterId) async {
    Chapter temp = Chapter();
    if (!page.hasContent()) return temp;

    temp.id = chapterId;
    temp.workId = workId;

    if (page.getElementsByClassName("chapter next").isNotEmpty) {
      String tempNext = page.getElementsByClassName("chapter next").first.innerHtml;
      temp.nextId = int.parse(tempNext.substring(tempNext.indexOf("chapters/")+9, tempNext.indexOf("#")));
    }

    if (page.getElementsByClassName("title heading").isNotEmpty) {
      temp.workTitle = page.getElementsByClassName("title heading").first.text.replaceAll("\n", "").trim();
    }

    if (chapterId == 0) {
      temp.num = "1";
      if (page.getElementsByClassName("title heading").isNotEmpty) {
        temp.title = page.getElementsByClassName("title heading").first.text.replaceAll("\n", "").trim();
      }
    }
    else {
      if (page.getElementsByClassName("chapter preface group").isNotEmpty) {
        String chapName = page
            .getElementsByClassName("chapter preface group")
            .first
            .children
            .first
            .text;
        if (chapName.contains(":")) {
          chapName = chapName.replaceAll("\n", "").trim();
          temp.num = chapName.substring(8, chapName.indexOf(":"));
          temp.title = chapName.substring(chapName.indexOf(":") + 2);
        }
        else {
          temp.num = chapName.substring(9).trim();
        }
      }
    }

    if (page.getElementsByClassName("summary module").isNotEmpty) temp.summary = convert(page.getElementsByClassName("summary module").first.getElementsByClassName("userstuff").first.innerHtml, styleOptions: {"hr":"- - -", "emDelimiter":"*", "bulletListMarker":"-"}); // Getting summary
    if (page.getElementsByClassName("notes module").isNotEmpty) {
      String notes = page.getElementsByClassName("notes module").first.innerHtml;
      temp.notes = convert(notes.replaceAll('<h3 class="heading">Notes:</h3>', "").replaceAll(RegExp(r"<blockquote.+"), ""), styleOptions: {"hr":"- - -", "emDelimiter":"*", "bulletListMarker":"-"}); // Getting notes
    }
    if (page.getElementById("work") != null) {
      String body = page.getElementById("work")!.parent!.innerHtml;
      temp.body = convert(
          body.replaceAll('<h3 class="landmark heading" id="work">Chapter Text</h3>', "")
              .replaceAll('<h3 class="landmark heading" id="work">Work Text:</h3>', "")
      , styleOptions: {"hr":"- - -", "emDelimiter":"*", "bulletListMarker":"-"}); // Getting body
    }
    else {
      temp.body = convert(page.body!.innerHtml as Object, styleOptions: {"hr":"- - -", "emDelimiter":"*", "bulletListMarker":"-"});
    }


    chapter_P.pushChapter(temp);

    return temp;
  }



  Future<History> addHistoryEntry(Work work, Chapter chapter) async {

    if (await history_P.checkIfHistoryExists(work.id, chapter.id)) {
      return await history_P.getHistory(work.id, chapter.id);
    }

    History history = History();

    history.workId = work.id;
    history.workName = work.title;
    history.author = work.author;
    history.chapId = chapter.id;
    history.chapNum = chapter.num;
    history.chapName = chapter.title;

    await history_P.pushHistory(history);

    return history;
  }

  Future<History> getHistory(int workId, int chapterId) async {
    return await history_P.getHistory(workId, chapterId);
  }

  Future<void> updateHistoryPos(int workId, int chapterId, double pos, double maxPos) async {
    History history = await history_P.getHistory(workId, chapterId);

    history.pos = pos;
    history.maxPos = maxPos;
    history.accessDate = DateTime.now();

    await history_P.pushHistory(history);
  }

}
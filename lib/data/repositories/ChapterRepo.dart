import 'package:ao3mobile/data/providers/HistoryProvider.dart';
import 'package:ao3mobile/data/repositories/WorkRepo.dart';
import 'package:html/dom.dart' as dom;
import 'package:html2md/html2md.dart';

import '../models/Chapter.dart';
import '../models/Work.dart';
import '../providers/A03Provider.dart';
import '../providers/ChapterProvider.dart';

class ChapterRepo {

  ChapterRepo();

  // Providers
  final AO3Provider ao3provider = new AO3Provider();
  final ChapterProvider chapterProvider = new ChapterProvider();
  final HistoryProvider historyProvider = new HistoryProvider();

  /// Gets Chapter object
  ///
  /// [refreshType] = 0 : Doesn't refresh - Only grabs database info
  ///
  /// [refreshType] = 1 : Soft refresh - Will attempt to refresh info if it has been more than 30 min from last fetch
  ///
  /// [refreshType] = 2 : Hard refresh - Will attempt to refresh info regardless of last fetch
  Future<Chapter> getChapter(int workId, int chapterId, [int refreshType = 0]) async {
    String table = await chapterProvider.whichTableIsChapterIn(workId, chapterId);
    if (table == "NONE" || refreshType == 2 || (refreshType == 1 && await chapterProvider.doesChapterNeedRefresh(workId, chapterId))) {
      if (table == "NONE") new WorkRepo().getWork(workId, 2, false);

      await parseRawPage(await ao3provider.getRawChapter(workId, chapterId), workId, chapterId);
    }

    Map<String, Object?> chapterData = await chapterProvider.getChapterData(workId, chapterId);
    if (chapterData.isEmpty) getChapter(workId, chapterId, refreshType+1); // Catching for failed caching

    return parseTableResult(chapterData);
  }

  Chapter createPartialChapter(int workId, int chapterId, String title, String num, int order) {
    Chapter temp = Chapter();

    temp.workId = workId;
    temp.id = chapterId;
    temp.title = title;
    temp.num = num;
    temp.order = order;

    chapterProvider.addChapterToCache(temp, false);
    return temp;
  }



  // Table parsing
  Chapter parseTableResult(Map<String, Object?> map) {
    Chapter temp = Chapter();

    temp.id = map["CHAP_ID"] as int;
    temp.workId = map["WORK_ID"] as int;
    temp.nextId = map["CHAP_ID_NEXT"] as int;
    temp.order = map["CHAP_ORDER"] as int;
    temp.num = map["NUM"] as String;
    temp.title = map["TITLE"] as String;
    temp.workTitle = map["WORK_TITLE"] as String;

    temp.summary = map["SUMMARY"] as String;
    temp.notes = map["NOTES"] as String;
    temp.body = map["BODY"] as String;

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

    if (chapterId == -1) {
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

    if (page.getElementsByClassName("summary module").isNotEmpty) temp.summary = convert(page.getElementsByClassName("summary module").first.getElementsByClassName("userstuff").first.innerHtml); // Getting summary
    if (page.getElementsByClassName("notes module").isNotEmpty) {
      String notes = page.getElementsByClassName("notes module").first.innerHtml;
      temp.notes = convert(notes.replaceAll('<h3 class="heading">Notes:</h3>', "").replaceAll(RegExp(r"<blockquote.+"), "")); // Getting notes
    }
    if (page.getElementById("work") != null) {
      String body = page.getElementById("work")!.parent!.innerHtml;
      temp.body = convert(
          body.replaceAll('<h3 class="landmark heading" id="work">Chapter Text</h3>', "")
              .replaceAll('<h3 class="landmark heading" id="work">Work Text:</h3>', "")
      ); // Getting body
    }
    else {
      temp.body = convert(page.body!.innerHtml as Object);
    }


    chapterProvider.addChapterToCache(temp);
    return temp;
  }



  Future<void> addHistoryEntry(Work work, Chapter chapter) async {
    await historyProvider.addHistoryEntry(work.id, work.title, work.author, chapter.id, chapter.num, chapter.title);
  }

  Future<void> updateHistoryPos(int workId, int chapterId, double pos, double maxPos) async {
    await historyProvider.updateHistoryPos(workId, chapterId, pos, maxPos);
  }

}
import 'package:ao3mobile/data/models/Chapter.dart';
import 'package:sembast/sembast.dart';

import '../DB/SDB.dart';



class Chapter_P {

  Chapter_P();

  static StoreRef<String, Map<String, dynamic>> ChapterStore = StoreRef<String, Map<String, dynamic>>("Chapter");

  Future<void> pushChapter(Chapter chapter) async {
    String key = "${chapter.workId}_${chapter.id}";
    await ChapterStore.record(key).put(await SDB.instance.temp, chapter.toMap());
    await ChapterStore.record(key).update(await SDB.instance.library, chapter.toMap());
  }

  Future<void> addChapterLibrary(Chapter chapter) async {
    String key = "${chapter.workId}_${chapter.id}";
    await ChapterStore.record(key).put(await SDB.instance.library, chapter.toMap());
  }

  Future<Chapter> getChapterTemp(int workId, int chapId) async {
    String key = "${workId}_${chapId}";
    return mapToChapter(ChapterStore.record(key).get(await SDB.instance.temp) as Map<String, dynamic>);
  }

  Future<Chapter> getChapterLibrary(int workId, int chapId) async {
    String key = "${workId}_${chapId}";
    return mapToChapter(ChapterStore.record(key).get(await SDB.instance.library) as Map<String, dynamic>);
  }

  Future<String> getChapterDB(int workId, int chapId) async {
    String key = "${workId}_${chapId}";
    if (await ChapterStore.record(key).get(await SDB.instance.temp) != null) return "TEMP";
    if (await ChapterStore.record(key).get(await SDB.instance.library) != null) return "LIBRARY";
    return "NONE";
  }

  Future<bool> doesChapterNeedRefresh(int workId, int chapId, String db) async {
    return true;
    late DateTime fetchDate;
    if (db == "LIBRARY") fetchDate = (await getChapterLibrary(workId, chapId)).lastFetchDate;
    if (db == "TEMP") fetchDate = (await getChapterTemp(workId, chapId)).lastFetchDate;
    return fetchDate.isBefore(DateTime.now().subtract(Duration(minutes: 30)));
  }



  Chapter mapToChapter(Map<String, dynamic> input) {
    Chapter temp = Chapter();

    if (input.containsKey("lastFetchDate")) temp.lastFetchDate = DateTime.parse(input["lastFetchDate"]);

    if (input.containsKey("id")) temp.id = input["id"];
    if (input.containsKey("workId")) temp.workId = input["workId"];
    if (input.containsKey("nextId")) temp.nextId = input["nextId"];
    if (input.containsKey("order")) temp.order = input["order"];
    if (input.containsKey("num")) temp.id = input["num"];
    if (input.containsKey("title")) temp.id = input["title"];
    if (input.containsKey("workTitle")) temp.id = input["workTitle"];

    if (input.containsKey("summary")) temp.summary = input["summary"];
    if (input.containsKey("notes")) temp.notes = input["notes"];
    if (input.containsKey("body")) temp.body = input["body"];

    return temp;
  }
}
import 'package:ao3mobile/data/models/Chapter.dart';
import 'package:ao3mobile/data/models/Work.dart';
import 'package:sembast/sembast.dart';

import '../DB/SDB.dart';



class Work_P {

  Work_P();

  static StoreRef<int, Map<String, dynamic>> WorkStore = StoreRef<int, Map<String, dynamic>>("Work");

  Future<void> pushWork(Work work) async {
    await WorkStore.record(work.id).put(await SDB.instance.temp, work.toMap());
    await WorkStore.record(work.id).update(await SDB.instance.library, work.toMap());
  }

  Future<void> addWorkLibrary(Work work) async {
    await WorkStore.record(work.id).put(await SDB.instance.library, work.toMap());
  }

  Future<Work> getWorkTemp(int id) async {
    return mapToWork(await WorkStore.record(id).get(await SDB.instance.temp) as Map<String, dynamic>);
  }

  Future<Work> getWorkLibrary(int id) async {
    return mapToWork(await WorkStore.record(id).get(await SDB.instance.library) as Map<String, dynamic>);
  }

  Future<String> getWorkDB(int id) async {
    if (await WorkStore.record(id).get(await SDB.instance.temp) != null) return "TEMP";
    if (await WorkStore.record(id).get(await SDB.instance.library) != null) return "LIBRARY";
    return "NONE";
  }

  Future<bool> doesWorkNeedRefresh(int id, String db) async {
    late DateTime fetchDate;
    if (db == "LIBRARY") fetchDate = (await getWorkLibrary(id)).lastFetchDate;
    if (db == "TEMP") fetchDate = (await getWorkTemp(id)).lastFetchDate;
    return fetchDate.isBefore(DateTime.now().subtract(Duration(minutes: 30)));
  }



  Work mapToWork(Map<String, dynamic> input) {
    Work temp = Work();

    if (input.containsKey("lastFetchDate")) temp.lastFetchDate = DateTime.parse(input["lastFetchDate"]);

    if (input.containsKey("id")) temp.id = input["id"];
    if (input.containsKey("title")) temp.title = input["title"];
    if (input.containsKey("author")) temp.author = input["author"];

    if (input.containsKey("ratingSymbol")) temp.ratingSymbol = ContentRating.values[(input["ratingSymbol"] as int)];
    if (input.containsKey("RPOSymbol")) temp.RPOSymbol = RPO.values[(input["RPOSymbol"] as int)];
    if (input.containsKey("warningSymbol")) temp.warningSymbol = ContentWarning.values[(input["warningSymbol"] as int)];
    if (input.containsKey("statusSymbol")) temp.statusSymbol = Status.values[(input["statusSymbol"] as int)];

    if (input.containsKey("rating")) temp.rating = input["rating"];
    if (input.containsKey("warning")) temp.warning = input["warning"];

    if (input.containsKey("categories")) temp.categories = (input["categories"] as List).cast<String>();
    if (input.containsKey("fandoms")) temp.fandoms = (input["fandoms"] as List).cast<String>();
    if (input.containsKey("relationships")) temp.relationships = (input["relationships"] as List).cast<String>();
    if (input.containsKey("characters")) temp.characters = (input["characters"] as List).cast<String>();
    if (input.containsKey("addTags")) temp.addTags = (input["addTags"] as List).cast<String>();

    if (input.containsKey("language")) temp.language = input["language"];

    if (input.containsKey("publishedDate")) temp.publishedDate = input["publishedDate"];
    if (input.containsKey("statusLabel")) temp.statusLabel = input["statusLabel"];
    if (input.containsKey("statusDate")) temp.statusDate = input["statusDate"];
    if (input.containsKey("words")) temp.words = input["words"];
    if (input.containsKey("chapterStats")) temp.chapterStats = input["chapterStats"];
    if (input.containsKey("comments")) temp.comments = input["comments"];
    if (input.containsKey("kudos")) temp.kudos = input["kudos"];
    if (input.containsKey("bookmarks")) temp.bookmarks = input["bookmarks"];
    if (input.containsKey("hits")) temp.hits = input["hits"];

    if (input.containsKey("summary")) temp.summary = input["summary"];

    if (input.containsKey("chapters")) {
      List<Map<String, dynamic>> cc = (input["chapters"] as List).cast<Map<String, dynamic>>();

      List<ChapterKey> chapters = [];
      for(Map<String, dynamic> ck in cc) {
        chapters.add(mapToChapterKey(ck));
      }

      temp.chapters = chapters;
    }

    return temp;
  }

  ChapterKey mapToChapterKey(Map<String, dynamic> input) {
    ChapterKey temp = ChapterKey();

    if (input.containsKey("id")) temp.id = input["id"];
    if (input.containsKey("workId")) temp.workId = input["workId"];
    if (input.containsKey("nextId")) temp.nextId = input["nextId"];
    if (input.containsKey("order")) temp.order = input["order"];
    if (input.containsKey("num")) temp.num = input["num"];
    if (input.containsKey("title")) temp.title = input["title"];
    if (input.containsKey("workTitle")) temp.workTitle = input["workTitle"];

    return temp;
  }
}
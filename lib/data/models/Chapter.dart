
class ChapterKey {

  ChapterKey();

  int id = -1;
  int workId = -1;
  int nextId = -1;
  int order = 1;
  String num = "";
  String title = "";
  String workTitle = "";

  Map<String, dynamic> toMap() {
    Map<String, dynamic> temp = {
      "id": id,
      "workId": workId,
      "nextId": nextId,
      "order": order,
      "num": num,
      "title": title,
      "workTitle": workTitle
    };

    return temp;
  }
}

class Chapter {

  Chapter();

  DateTime lastFetchDate = DateTime.now();

  int id = -1;
  int workId = -1;
  int nextId = -1;
  int order = 1;
  String num = "";
  String title = "";
  String workTitle = "";

  String summary = "";
  String notes = "";
  String body = "";

  Map<String, dynamic> toMap() {
    Map<String, dynamic> temp = {
      "lastFetchDate": lastFetchDate.toIso8601String(),

      "id": id,
      "workId": workId,
      "nextId": nextId,
      "order": order,
      "num": num,
      "title": title,
      "workTitle": workTitle,

      "summary": summary,
      "notes": notes,
      "body": body
    };

    return temp;
  }
}



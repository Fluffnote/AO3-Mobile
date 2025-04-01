class History {

  int workId = -1;
  String workName = "";
  String author = "";
  int chapId = -1;
  String chapNum = "";
  String chapName = "";
  double pos = 0;
  double maxPos = 1;
  DateTime accessDate = DateTime.now();

  History();

  factory History.parse(Map<String, Object?> results) {
    History temp = new History();

    temp.workId = results["WORK_ID"] as int;
    temp.workName = results["WORK_NAME"] as String;
    temp.author = results["AUTHOR"] as String;
    temp.chapId = results["CHAP_ID"] as int;
    temp.chapNum = results["CHAP_NUM"] as String;
    temp.chapName = results["CHAP_NAME"] as String;
    temp.pos = results["POS"] as double;
    temp.maxPos = results["MAX_POS"] as double;
    temp.accessDate = DateTime.parse(results["ACCESS_DATE"] as String);

    return temp;
  }

}
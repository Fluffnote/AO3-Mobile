class History {

  History();

  int workId = 0;
  String workName = "";
  String author = "";
  int chapId = 0;
  String chapNum = "";
  String chapName = "";
  double pos = 0;
  double maxPos = 1;
  DateTime accessDate = DateTime.now();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> temp = {
      "workId": workId,
      "workName": workName,
      "author": author,
      "chapId": chapId,
      "chapNum": chapNum,
      "chapName": chapName,
      "pos": pos,
      "maxPos": maxPos,
      "accessDate": accessDate.toIso8601String()
    };

    return temp;
  }

}
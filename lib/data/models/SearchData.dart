import 'package:ao3mobile/data/models/Work.dart';

class SearchData {

  SearchData();

  String numFound = "";
  List<int> workIds = [];
  List<Work> works = [];

  List<dynamic> toList() {
    List<dynamic> temp = [numFound];

    for(int workId in workIds) {
      temp.add(workId);
    }

    return temp;
  }
}
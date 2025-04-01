import 'Chapter.dart';



class Work {

  Work();

  int id = -1;
  String title = "";
  String author = "";

  String rating = "";
  String warning = "";
  List<String> categories = [];
  List<String> fandoms = [];
  List<String> relationships = [];
  List<String> characters = [];
  List<String> addTags = [];
  String language = "";

  // Stats
  String publishedDate = "";
  String statusLabel = "";
  String statusDate = "";
  int words = 0;
  String chapterStats = "";
  int comments = 0;
  int kudos = 0;
  int bookmarks = 0;
  int hits = 0;

  String summary = "";

  List<Chapter> chapters = [];
}


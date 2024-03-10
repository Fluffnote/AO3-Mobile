import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:html2md/html2md.dart';
import 'package:http/http.dart' as http;

Future<Work> getWork(int workId) async {
  http.Response response = await http.get(Uri.parse("https://archiveofourown.org/works/$workId?view_adult=true"));
  return Work.createWork(parse(response.body));
}

class Work {

  int id = -1;
  String title = "";
  String author = "";

  String rating = "";
  String archiveWarning = "";
  List<String> categories = [];
  String fandom = "";
  List<String> relationships = [];
  List<String> characters = [];
  List<String> addTags = [];
  String language = "";

  // Stats
  String publishedDate = "";
  String statusLabel = "";
  String statusDate = "";
  String words = "";
  String chapterStats = "";
  String comments = "";
  String kudos = "";
  String bookmarks = "";
  String hits = "";

  String firstSummary = "";

  List<Chapter> chapters = [];

  Work();

  factory Work.createWork(dom.Document page) {
    Work temp = Work();
    if (!page.hasContent()) return temp;

    String tempURLClipping = page.getElementsByClassName("chapter preface group").first.children.first.innerHtml.substring(17);
    temp.id = int.parse(tempURLClipping.substring(0, tempURLClipping.indexOf("/")));
    temp.title = page.body!.getElementsByClassName("title heading").first.text.trim();
    temp.author = page.body!.getElementsByClassName("byline heading").first.text.trim();

    // Getting work info
    temp.rating = page.getElementsByClassName("rating tags").last.children.first.children.first.text; // Adding rating
    temp.archiveWarning = page.getElementsByClassName("warning tags").last.children.first.children.first.text; // Adding warning
    for(dom.Element elem in page.getElementsByClassName("category tags").last.children.first.children) { // Adding categories
      temp.categories.add(elem.children.first.text);
    }
    temp.fandom = page.getElementsByClassName("fandom tags").last.children.first.children.first.text; // Adding fandom
    for(dom.Element elem in page.getElementsByClassName("relationship tags").last.children.first.children) { // Adding relationships
      temp.relationships.add(elem.children.first.text);
    }
    for(dom.Element elem in page.getElementsByClassName("character tags").last.children.first.children) { // Adding characters
      temp.characters.add(elem.children.first.text);
    }
    for(dom.Element elem in page.getElementsByClassName("freeform tags").last.children.first.children) { // Adding additional tags
      temp.addTags.add(elem.text);
    }
    temp.language = page.getElementsByClassName("language").last.text.replaceAll("\n", ""); // Adding language

    // Getting stats
    dom.Element stats = page.getElementsByClassName("stats").last;
    temp.publishedDate = stats.getElementsByClassName("published").last.text;
    temp.statusLabel = stats.getElementsByClassName("status").first.text.replaceFirst(":", "");
    temp.statusDate = stats.getElementsByClassName("status").last.text;
    temp.words = stats.getElementsByClassName("words").last.text;
    temp.chapterStats = stats.getElementsByClassName("chapters").last.text;
    temp.comments = stats.getElementsByClassName("comments").last.text;
    temp.kudos = stats.getElementsByClassName("kudos").last.text;
    temp.bookmarks = stats.getElementsByClassName("bookmarks").last.text;
    temp.hits = stats.getElementsByClassName("hits").last.text;

    // Adding chapter info
    for(dom.Element elem in page.getElementById("chapter_index")!.children.first.children.first.children.first.children.first.children) {
      if (elem.outerHtml.contains('<span class="submit actions">')) continue;
      String tempIDClipping = elem.outerHtml.substring(elem.outerHtml.indexOf('value="')+7);
      temp.chapters.add(Chapter.create(
          id: int.parse(tempIDClipping.substring(0, tempIDClipping.indexOf('"'))),
          title: tempIDClipping.substring(tempIDClipping.indexOf(".")+2, tempIDClipping.indexOf("<")),
          num: tempIDClipping.substring(tempIDClipping.indexOf(">")+1, tempIDClipping.indexOf("."))
      ));
    }

    // Getting first summary
    temp.firstSummary = convert(page.getElementsByClassName("summary module").first.getElementsByClassName("userstuff").first.innerHtml);

    return temp;
  }
}

Future<Chapter> getChapter(int workId, int chapterId) async {
  http.Response response = await http.get(Uri.parse("https://archiveofourown.org/works/$workId/chapters/$chapterId?view_adult=true"));
  return Chapter.getChapter(parse(response.body));
}

class Chapter {

  int id = -1;
  String num = "";
  String title = "";

  String summary = "";
  String notes = "";
  String body = "";

  Chapter();
  Chapter.create({
    required this.id,
    required this.title,
    required this.num,
  });

  factory Chapter.getChapter(dom.Document page) {
    Chapter temp = Chapter();
    if (!page.hasContent()) return temp;

    String chapName = page.getElementsByClassName("chapter preface group").first.children.first.text;
    if (chapName.contains(":")) {
      temp.num = chapName.substring(9,chapName.indexOf(":"));
      temp.title = chapName.substring(chapName.indexOf(":")+2).replaceAll("\n", "");
    }
    else temp.num = chapName.substring(9).trim();

    if (page.getElementsByClassName("summary module").isNotEmpty) temp.summary = convert(page.getElementsByClassName("summary module").first.getElementsByClassName("userstuff").first.innerHtml); // Getting summary
    if (page.getElementsByClassName("notes module").isNotEmpty) {
      String notes = page.getElementsByClassName("notes module").first.innerHtml;
      print(notes.replaceAll('<h3 class="heading">Notes:</h3>', "").replaceAll(RegExp(r"<blockquote.+"), ""));
      temp.notes = convert(notes.replaceAll('<h3 class="heading">Notes:</h3>', "").replaceAll(RegExp(r"<blockquote.+"), "")); // Getting notes
    }
    temp.body = convert(page.getElementsByClassName("userstuff module").first.innerHtml.replaceAll('<h3 class="landmark heading" id="work">Chapter Text</h3>', "")); // Getting body

    return temp;
  }
}
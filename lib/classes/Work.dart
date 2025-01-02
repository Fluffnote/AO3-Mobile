import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:html2md/html2md.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'Chapter.dart';




// Work functions
Future<Work> getWork(int workId) async {
  http.Response response = await http.get(Uri.parse("https://archiveofourown.org/works/$workId?view_adult=true"));
  return Work.createWork(parse(response.body), workId);
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

  factory Work.createWork(dom.Document page, int workId) {
    Work temp = Work();
    if (!page.hasContent()) return temp;

    temp.id = workId;
    temp.title = page.body!.getElementsByClassName("title heading").first.text.trim();
    temp.author = page.body!.getElementsByClassName("byline heading").first.text.trim();

    // Getting work info
    temp.rating = page.getElementsByClassName("rating tags").last.children.first.children.first.text; // Adding rating
    temp.archiveWarning = page.getElementsByClassName("warning tags").last.children.first.children.first.text; // Adding warning
    if (page.getElementsByClassName("category tags").isNotEmpty) { // Adding categories
      for(dom.Element elem in page.getElementsByClassName("category tags").last.children.first.children) {
        temp.categories.add(elem.children.first.text);
      }
    }
    temp.fandom = page.getElementsByClassName("fandom tags").last.children.first.children.first.text; // Adding fandom
    if (page.getElementsByClassName("relationship tags").isNotEmpty) { // Adding relationships
      for(dom.Element elem in page.getElementsByClassName("relationship tags").last.children.first.children) {
        temp.relationships.add(elem.children.first.text);
      }
    }
    if (page.getElementsByClassName("character tags").isNotEmpty) { // Adding characters
      for(dom.Element elem in page.getElementsByClassName("character tags").last.children.first.children) {
        temp.characters.add(elem.children.first.text);
      }
    }
    if (page.getElementsByClassName("freeform tags").isNotEmpty) { // Adding additional tags
      for(dom.Element elem in page.getElementsByClassName("freeform tags").last.children.first.children) {
        temp.addTags.add(elem.text);
      }
    }
    temp.language = page.getElementsByClassName("language").last.text.replaceAll("\n", ""); // Adding language

    // Getting stats
    dom.Element stats = page.getElementsByClassName("stats").last;
    temp.publishedDate = stats.getElementsByClassName("published").last.text;
    if (stats.getElementsByClassName("status").isNotEmpty) {
      temp.statusLabel = stats.getElementsByClassName("status").first.text.replaceFirst(":", "");
      temp.statusDate = stats.getElementsByClassName("status").last.text;
    }
    if (stats.getElementsByClassName("words").isNotEmpty) temp.words = stats.getElementsByClassName("words").last.text;
    if (stats.getElementsByClassName("chapters").isNotEmpty) temp.chapterStats = stats.getElementsByClassName("chapters").last.text;
    if (stats.getElementsByClassName("comments").isNotEmpty) temp.comments = stats.getElementsByClassName("comments").last.text;
    if (stats.getElementsByClassName("kudos").isNotEmpty) temp.kudos = stats.getElementsByClassName("kudos").last.text;
    if (stats.getElementsByClassName("bookmarks").isNotEmpty) temp.bookmarks = stats.getElementsByClassName("bookmarks").last.text;
    if (stats.getElementsByClassName("hits").isNotEmpty) temp.hits = stats.getElementsByClassName("hits").last.text;

    // TO DO: account for only one chapter (ex: 47452786)
    // Adding chapter info
    if (page.getElementById("chapter_index") != null) {
      for (dom.Element elem in page
          .getElementById("chapter_index")!
          .children
          .first
          .children
          .first
          .children
          .first
          .children
          .first
          .children) {
        if (elem.outerHtml.contains('<span class="submit actions">')) continue;
        String tempIDClipping = elem.outerHtml.substring(
            elem.outerHtml.indexOf('value="') + 7);
        temp.chapters.add(Chapter.create(
            id: int.parse(
                tempIDClipping.substring(0, tempIDClipping.indexOf('"'))),
            title: tempIDClipping.substring(
                tempIDClipping.indexOf(".") + 2, tempIDClipping.indexOf("<")),
            num: tempIDClipping.substring(
                tempIDClipping.indexOf(">") + 1, tempIDClipping.indexOf("."))
        ));
      }
    }

    // Getting first summary
    if (page.getElementsByClassName("summary module").isNotEmpty) temp.firstSummary = convert(page.getElementsByClassName("summary module").first.getElementsByClassName("userstuff").first.innerHtml);

    return temp;
  }
}

Future<void> openWebPage(int work) async {
  Uri uri =  Uri.parse("https://archiveofourown.org/works/$work?view_adult=true");
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $uri');
  }
}



class PartialWork {

  int id = -1;
  String title = "";
  String author = "";

  String rating = "";
  List<String> categories = [];
  List<String> fandoms = [];
  List<String> tags = [];
  String language = "";

  // Stats
  String lastEditDate = "";
  String chapters = "";
  String words = "";
  String chapterStats = "";
  String comments = "";
  String kudos = "";
  String bookmarks = "";
  String hits = "";

  String summary = "";

  PartialWork();

  factory PartialWork.create(dom.Element part) {
    PartialWork temp = PartialWork();
    if (!part.hasContent()) return temp;

    temp.id = int.parse(part.id.replaceAll("work_", ""));

    dom.Element header = part.getElementsByClassName("header module").first;
    temp.title = header.children.first.children.first.text;
    temp.author = header.children.first.children.last.text;

    for(dom.Element fandomElem in header.getElementsByClassName("fandoms heading").first.children) {
      if (fandomElem.text.trim() == "Fandoms:") continue;
      temp.fandoms.add(fandomElem.text);
    }

    if (part.getElementsByClassName("tags commas").isNotEmpty) {
      dom.Element tags = part.getElementsByClassName("tags commas").first;

      for(dom.Element tagElem in tags.children) {
        temp.tags.add(tagElem.text);
      }
    }

    dom.Element stats = part.getElementsByClassName("stats").first;
    temp.lastEditDate = header.getElementsByClassName("datetime").first.text;
    if (stats.getElementsByClassName("language").isNotEmpty) temp.language = stats.getElementsByClassName("language").last.text;
    if (stats.getElementsByClassName("chapters").isNotEmpty) temp.chapters = stats.getElementsByClassName("chapters").last.text;
    if (stats.getElementsByClassName("words").isNotEmpty) temp.words = stats.getElementsByClassName("words").last.text;
    if (stats.getElementsByClassName("comments").isNotEmpty) temp.comments = stats.getElementsByClassName("comments").last.text;
    if (stats.getElementsByClassName("kudos").isNotEmpty) temp.kudos = stats.getElementsByClassName("kudos").last.text;

    if (part.getElementsByClassName("userstuff summary").isNotEmpty) {
      temp.summary = convert(part.getElementsByClassName("userstuff summary").first.innerHtml);
    }

    return temp;
  }
}

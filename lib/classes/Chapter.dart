import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:html2md/html2md.dart';
import 'package:http/http.dart' as http;



Future<Chapter> getChapter(int workId, int chapterId) async {
  http.Response response = await http.get(Uri.parse("https://archiveofourown.org/works/$workId/chapters/$chapterId?view_adult=true"));
  return Chapter.getChapter(parse(response.body));
}

class Chapter {

  int id = -1;
  int nextId = -1;
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
      chapName = chapName.replaceAll("\n", "").trim();
      temp.num = chapName.substring(8,chapName.indexOf(":"));
      temp.title = chapName.substring(chapName.indexOf(":")+2);
    }
    else {
      temp.num = chapName.substring(9).trim();
    }

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
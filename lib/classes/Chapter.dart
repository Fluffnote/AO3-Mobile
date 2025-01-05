import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:html2md/html2md.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';



Future<Chapter> getChapter(int workId, int chapterId) async {
  http.Response response;
  final client = RetryClient(http.Client());
  try {
    if (chapterId == -1) {
      response = await client.get(Uri.parse("https://archiveofourown.org/works/$workId#workskin?view_adult=true"));
    }
    else {
      response = await client.get(Uri.parse("https://archiveofourown.org/works/$workId/chapters/$chapterId#workskin?view_adult=true"));
    }
  }
  finally {
    client.close();
  }
  return Chapter.getChapter(workId, chapterId, parse(response.body));
}

class Chapter {

  int id = -1;
  int workId = -1;
  int nextId = -1;
  String num = "";
  String title = "";
  String workTitle = "";

  String summary = "";
  String notes = "";
  String body = "";

  Chapter();
  Chapter.create({
    required this.workId,
    required this.id,
    required this.title,
    required this.num,
  });

  factory Chapter.getChapter(int workId, int chapterId, dom.Document page) {
    Chapter temp = Chapter();
    if (!page.hasContent()) return temp;

    if (page.getElementsByClassName("chapter next").isNotEmpty) {
      String tempNext = page.getElementsByClassName("chapter next").first.innerHtml;
      temp.nextId = int.parse(tempNext.substring(tempNext.indexOf("chapters/")+9, tempNext.indexOf("#")));
    }

    if (page.getElementsByClassName("title heading").isNotEmpty) {
      temp.workTitle = page.getElementsByClassName("title heading").first.text.replaceAll("\n", "").trim();
    }

    if (chapterId == -1) {
      temp.title = page.getElementsByClassName("title heading").first.text.replaceAll("\n", "").trim();
    }
    else {
      if (page.getElementsByClassName("chapter preface group").isNotEmpty) {
        String chapName = page
            .getElementsByClassName("chapter preface group")
            .first
            .children
            .first
            .text;
        if (chapName.contains(":")) {
          chapName = chapName.replaceAll("\n", "").trim();
          temp.num = chapName.substring(8, chapName.indexOf(":"));
          temp.title = chapName.substring(chapName.indexOf(":") + 2);
        }
        else {
          temp.num = chapName.substring(9).trim();
        }
      }
    }

    if (page.getElementsByClassName("summary module").isNotEmpty) temp.summary = convert(page.getElementsByClassName("summary module").first.getElementsByClassName("userstuff").first.innerHtml); // Getting summary
    if (page.getElementsByClassName("notes module").isNotEmpty) {
      String notes = page.getElementsByClassName("notes module").first.innerHtml;
      temp.notes = convert(notes.replaceAll('<h3 class="heading">Notes:</h3>', "").replaceAll(RegExp(r"<blockquote.+"), "")); // Getting notes
    }
    if (page.getElementById("work") != null) {
      String body = page.getElementById("work")!.parent!.innerHtml;
      temp.body = convert(
          body.replaceAll('<h3 class="landmark heading" id="work">Chapter Text</h3>', "")
              .replaceAll('<h3 class="landmark heading" id="work">Work Text:</h3>', "")
      ); // Getting body
    }
    else {
      temp.body = convert(page.body!.innerHtml as Object);
    }


    return temp;
  }
}
import 'package:ao3mobile/data/providers/A03Provider.dart';
import 'package:ao3mobile/data/providers/SearchProvider.dart';
import 'package:ao3mobile/data/repositories/WorkRepo.dart';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart' as dom;

import '../models/SearchData.dart';
import '../models/SearchQueryParameters.dart';
import '../models/Work.dart';

class SearchRepo {

  SearchRepo();

  final WorkRepo workRepo = new WorkRepo();

  final SearchProvider searchProvider = new SearchProvider();
  final AO3Provider ao3provider = new AO3Provider();


  Future<SearchData> workSearch(SearchQueryParameters params) async {

    searchProvider.clearSearchResults();

    dom.Document page = await ao3provider.getRawSearch(params);
    // Can't find any results
    if (page.getElementsByClassName("work index group").isEmpty) return SearchData();
    List<Work> out = [];
    String numFound = "";

    String numFoundRaw = page.getElementById("main")?.children.elementAt(4).text ?? "";
    numFound = (numFoundRaw.isNotEmpty)?numFoundRaw.substring(0, numFoundRaw.indexOf("Found")+5):"";

    for(dom.Element elem in page.getElementsByClassName("work index group").first.children) {
      Work work = await workRepo.parseRawSearchPart(elem);
      searchProvider.addWorkToSearchResults(work.id);
      out.add(work);
    }

    if (kDebugMode) print("Search finished: ${out.length}");
    return SearchData(numFound:numFound, works: out);
  }
}
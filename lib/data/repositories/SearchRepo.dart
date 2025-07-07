import 'package:ao3mobile/data/providers/AO3_P.dart';
import 'package:ao3mobile/data/repositories/WorkRepo.dart';
import 'package:flutter/foundation.dart';
import 'package:html/dom.dart' as dom;

import '../models/SearchData.dart';
import '../models/SearchQueryParameters.dart';
import '../models/Work.dart';
import '../providers/Search_P.dart';

class SearchRepo {

  SearchRepo();

  final WorkRepo workRepo = WorkRepo();

  final Search_P search_P = Search_P();
  final AO3_P ao3_P = AO3_P();

  SearchData searchData = SearchData();


  Future<SearchData> workSearch(SearchQueryParameters params) async {

    if (params.page == 1) {
      await search_P.clearStore();
      searchData = SearchData();
    }

    dom.Document page = await ao3_P.getRawSearch(params);
    // Can't find any results
    if (page.getElementsByClassName("work index group").isEmpty) searchData;

    String numFoundRaw = page.getElementById("main")?.children.elementAt(4).text ?? "";
    searchData.numFound = (numFoundRaw.isNotEmpty)?numFoundRaw.substring(0, numFoundRaw.indexOf("Found")+5):"";

    for(dom.Element elem in page.getElementsByClassName("work index group").first.children) {
      Work work = await workRepo.parseRawSearchPart(elem);
      searchData.workIds.add(work.id);
      searchData.works.add(work);
    }

    await search_P.updateSearchinfo(searchData.toList());

    return searchData;
  }
}
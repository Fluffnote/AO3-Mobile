import 'package:ao3mobile/data/Singletons/ClientKeeper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:ao3mobile/main.dart';

import '../../views/htmlView.dart';
import '../models/SearchQueryParameters.dart';

class AO3Provider {

  AO3Provider();

  Future<dom.Document> clientGet(Uri uri) async {
    if (kDebugMode) print(uri.toString());
    Response response = await (await ClientKeeper.instance.client).requestUri(uri);
    dom.Document page = parse(response.data);

    // navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => HTMLView(body: response.body)));

    return page;
  }

  Future<String> clientGetBody(Uri uri) async {
    if (kDebugMode) print(uri.toString());
    Response response = await (await ClientKeeper.instance.client).requestUri(uri);

    // navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => HTMLView(body: response.body)));

    return response.data;
  }

  Future<dom.Document> getRawSearch(SearchQueryParameters params) async {

    Uri httpsSearch = Uri(
        scheme: 'https',
        host: 'archiveofourown.org',
        path: 'works/search',
        queryParameters: params.getParams()
    );

    if (kDebugMode) print("Search started: $httpsSearch");

    return await clientGet(httpsSearch);
  }

  Future<dom.Document> getRawWork(int workId) async {
    Uri uri = Uri.parse("https://archiveofourown.org/works/$workId?view_adult=true");
    if (kDebugMode) print("Getting work: $uri");
    return await clientGet(uri);
  }

  Future<void> openRawWorkHTML(int workId) async {
    Uri uri = Uri.parse("https://archiveofourown.org/works/$workId?view_adult=true");
    String body = await clientGetBody(uri);
    navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => HTMLView(body: body)));
  }

  Future<dom.Document> getRawChapter(int workId, int chapterId) async {
    Uri uri;
    if (chapterId == -1) {
      uri = Uri.parse("https://archiveofourown.org/works/$workId?view_adult=true");
    }
    else {
      uri = Uri.parse("https://archiveofourown.org/works/$workId/chapters/$chapterId?view_adult=true");
    }
    return await clientGet(uri);
  }

}
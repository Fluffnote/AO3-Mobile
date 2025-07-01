import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:http/retry.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ClientKeeper {

  ClientKeeper._internal();

  static final ClientKeeper _CK = ClientKeeper._internal();
  static ClientKeeper get instance => _CK;
  static var _client;
  static var _cookies;

  final options = BaseOptions(baseUrl: "https://archiveofourown.org");

  Map<String, String> headers = {};

  Future<Dio> get client async {
    if (_client != null) return _client;

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    _cookies = PersistCookieJar(
        ignoreExpires: true,
        storage: FileStorage(appDocPath + "/.cookies/")
    );
    _client = Dio(options);
    _client.interceptors.add(CookieManager(_cookies));

    return _client;
  }

  Future<void> closeClient() async {
    if (_client != null) (_client as RetryClient).close();
  }
}
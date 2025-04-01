import 'package:http/retry.dart';
import 'package:http/http.dart' as http;

class ClientKeeper {

  static final ClientKeeper _CK = new ClientKeeper._internal();
  ClientKeeper._internal();
  static ClientKeeper get instance => _CK;
  static var _client;

  Map<String, String> headers = {};

  Future<RetryClient> get client async {
    if (_client != null) return _client;
    _client = RetryClient(http.Client());
    return _client;
  }

  Future<void> closeClient() async {
    if (_client != null) (_client as RetryClient).close();
  }

  void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}
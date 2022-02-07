import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import 'rest_result.dart';
import 'mix_result.dart';

/// HTTP methods.
enum MethodType {
  delete,
  get,
  head,
  patch,
  post,
  put,
}

/// Minigun REST client.
class Client {
  static final log = Logger('Client');

  // ----------------------------------------------------------------------

  /// Base URI.
  late final String _baseUri;
  String get baseUri => _baseUri;

  /// Constructor.
  Client({required String baseUri}) {
    if (!baseUri.endsWith('/')) baseUri += '/';
    _baseUri = baseUri;
  }

  // ----------------------------------------------------------------------

  /// Authen token.
  String _token = '';
  String get token => _token;

  Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + _token,
    };
  }

  Uri getUri(String address, [Map<String, String>? query]) {
    var params = Uri(queryParameters: query).query;
    if (params != '') params = '?$params';
    final uri = Uri.parse('$baseUri$address$params');
    log.info('URI: $uri');
    return uri;
  }

  Future<MixResult> call(
    MethodType method,
    Uri uri, {
    Object? body,
  }) async {
    try {
      late http.Response res;
      switch (method) {
        case MethodType.delete:
          res = await http.delete(uri, headers: getHeaders(), body: body);
          break;
        case MethodType.get:
          res = await http.get(uri, headers: getHeaders());
          break;
        case MethodType.head:
          res = await http.head(uri, headers: getHeaders());
          break;
        case MethodType.patch:
          res = await http.patch(uri, headers: getHeaders(), body: body);
          break;
        case MethodType.post:
          res = await http.post(uri, headers: getHeaders(), body: body);
          break;
        case MethodType.put:
          res = await http.put(uri, headers: getHeaders(), body: body);
          break;
      }
      return MixResult(RestResult(res));
    } catch (ex) {
      log.severe(ex);
      return MixResult.error(ex);
    }
  }

  Future<MixResult> callRaw(
    MethodType method,
    Uri uri, {
    Object? body,
  }) async {
    try {
      late http.Response res;
      switch (method) {
        case MethodType.delete:
          res = await http.delete(uri, headers: getHeaders(), body: body);
          break;
        case MethodType.get:
          res = await http.get(uri, headers: getHeaders());
          break;
        case MethodType.head:
          res = await http.head(uri, headers: getHeaders());
          break;
        case MethodType.patch:
          res = await http.patch(uri, headers: getHeaders(), body: body);
          break;
        case MethodType.post:
          res = await http.post(uri, headers: getHeaders(), body: body);
          break;
        case MethodType.put:
          res = await http.put(uri, headers: getHeaders(), body: body);
          break;
      }
      return MixResult(RestResult.raw(res));
    } catch (ex) {
      log.severe(ex);
      return MixResult.error(ex);
    }
  }

  http.MultipartRequest prepareMultipart(String method, Uri uri) {
    final req = http.MultipartRequest(method, uri);
    req.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ' + _token,
    });
    return req;
  }

  Future<MixResult> callMultipart(http.MultipartRequest req) async {
    try {
      final res = await req.send();
      return MixResult(RestResult(await http.Response.fromStream(res)));
    } catch (ex) {
      log.severe(ex);
      return MixResult.error(ex);
    }
  }

  final converter = JsonEncoder.withIndent('  ');
  String jsonToString(Map<String, dynamic> json) => converter.convert(json);

  // ----------------------------------------------------------------------

  Future<MixResult> login({
    required String username,
    required String password,
  }) async {
    final json = {
      'login': {
        'username': username,
        'password': password,
      },
    };
    final result = await call(
      MethodType.put,
      getUri('authen/login'),
      body: jsonEncode(json),
    );
    if (result.isOk() && result.rest!.ok) {
      final rest = result.rest!;
      _token = rest.json['user']['token'];
    }
    return result;
  }

  Future<MixResult> logout() async {
    return await call(
      MethodType.put,
      getUri('authen/logout'),
    );
  }

  Future<MixResult> check() async {
    return await call(
      MethodType.get,
      getUri('authen/check'),
    );
  }
}

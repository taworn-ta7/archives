import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import 'rest_error.dart';

/// REST call result.
class RestResult {
  static final log = Logger('RestResult');

  late final http.Response res;
  late final bool ok;
  late final Map<String, dynamic> json;
  late final RestError? error;

  RestResult(this.res) {
    ok = [200, 201].contains(res.statusCode);
    json = jsonDecode(res.body);
    if (json.containsKey('error')) {
      error = RestError.fromJson(json['error']);
    } else {
      error = null;
    }

    final req = res.request!;
    if (error != null) {
      log.warning('${req.method} ${req.url}: $error');
    } else {
      log.info('${req.method} ${req.url}: ok');
    }
  }

  RestResult.raw(this.res) {
    ok = [200, 201].contains(res.statusCode);
    if (!ok) {
      json = jsonDecode(res.body);
      if (json.containsKey('error')) {
        error = RestError.fromJson(json['error']);
      } else {
        error = null;
      }
    }

    final req = res.request!;
    if (!ok) {
      log.warning('${req.method} ${req.url}: $error');
    } else {
      log.info('${req.method} ${req.url}: ok');
    }
  }

  bool isOk() => ok;
}

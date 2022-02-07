import 'rest_result.dart';

/// Mix call error between REST and exception error.
class MixResult {
  late final RestResult? rest;
  late final Object? error;

  MixResult(this.rest) {
    error = null;
  }

  MixResult.error(this.error) {
    rest = null;
  }

  bool isOk() => rest != null ? rest!.ok : false;
}

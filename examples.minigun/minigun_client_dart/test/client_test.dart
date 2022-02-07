import 'package:test/test.dart';
import 'package:minigun_client_dart/minigun_client.dart';
import 'constants.dart';

void main() {
  ///
  /// Test client.
  ///
  group('test client', () {
    final client = Client(baseUri: Constants.baseUri);

    setUp(() async {
      await client.login(
        username: Constants.username,
        password: Constants.password,
      );
    });

    tearDown(() async {
      await client.logout();
    });

    test('test check()', () async {
      final result = await client.check();
      expect(result.rest!.res.statusCode, equals(200));
    });
  });
}

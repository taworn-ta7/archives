import 'dart:math';
import 'package:test/test.dart';
import 'package:minigun_client_dart/minigun_client.dart';
import 'constants.dart';

void main() {
  ///
  /// Test client/product #0.
  ///
  group('test client/product #0', () {
    final client = Client(baseUri: Constants.baseUri);

    final randomize = Random();
    final random = randomize.nextInt(10000);
    final suffix = random.toString().padLeft(4, '0');

    setUp(() async {
      await client.login(
        username: Constants.username,
        password: Constants.password,
      );
    });

    tearDown(() async {
      await client.logout();
    });

    test('test findAll()', () async {
      final result = await productFindAll(
        client,
      );
      expect(result.rest!.res.statusCode, equals(200));
    });

    test('test overall', () async {
      late int lastId;

      {
        // create product
        final result = await productCreate(
          client,
          name: 'PRODUCT-TEST$suffix',
        );
        lastId = result.rest!.json['product']['id'];
      }

      {
        // create SKU
        await skuCreate(
          client,
          code: 'SKU-TEST$suffix',
          cost: '10.00',
          price: '20.00',
          quantity: 30,
        );
      }

      {
        // update product with created SKU
        final result = await productUpdate(
          client,
          id: lastId,
          skus: [
            'SKU-TEST$suffix',
          ],
        );
        expect(result.rest!.res.statusCode, equals(200));
      }

      {
        // find one
        final result = await productFindOne(
          client,
          id: lastId,
        );
        expect(result.rest!.res.statusCode, equals(200));
      }
    });
  });
}

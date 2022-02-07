import 'dart:math';
import 'package:test/test.dart';
import 'package:sample_stock_client_dart/sample_stock_client.dart';
import 'constants.dart';

void main() {
  ///
  /// Test client/sku #0.
  ///
  group('test client/sku #0', () {
    final client = SampleStockClient(baseUri: Constants.baseUri);

    final randomize = Random();
    final random = randomize.nextInt(10000);
    final suffix = random.toString().padLeft(4, '0');

    setUp(() async {
      await client.login(
        username: Constants.username,
        password: Constants.password,
      );

      await skuCreate(
        client,
        code: 'SKU-TEST$suffix',
        cost: '99.99',
        price: '100.00',
        quantity: 55555,
      );
    });

    tearDown(() async {
      await skuRemove(
        client,
        code: 'SKU-TEST$suffix',
      );
    });

    test('test findAll()', () async {
      final result = await skuFindAll(
        client,
      );
      expect(result.rest!.res.statusCode, equals(200));
    });

    test('test findOne(), success', () async {
      final result = await skuFindOne(
        client,
        code: 'SKU-TEST$suffix',
      );
      expect(result.rest!.res.statusCode, equals(200));
    });

    test('test findOne(), fail', () async {
      final random = randomize.nextInt(10000);
      final suffix = random.toString().padLeft(4, '0');
      final result = await skuFindOne(
        client,
        code: 'TEST-$suffix-NO_ONE_NAME',
      );
      expect(result.rest!.res.statusCode, equals(404));
    });

    test('test update()', () async {
      final result = await skuUpdate(
        client,
        code: 'SKU-TEST$suffix',
        barcode: '123456789012',
        price: '200.00',
        quantity: 7777777,
      );
      expect(result.rest!.res.statusCode, equals(200));
    });
  });

  ///
  /// Test client/sku #1.
  ///
  group('test client/sku #1', () {
    final client = SampleStockClient(baseUri: Constants.baseUri);

    final randomize = Random();
    final random = randomize.nextInt(10000);
    final suffix = random.toString().padLeft(4, '0');

    setUp(() async {
      await client.login(
        username: 'user0',
        password: 'user0//pass',
      );

      await skuCreate(
        client,
        code: 'SKU-TEST$suffix',
        cost: '1000.00',
        price: '2000.00',
        quantity: 3000,
      );
    });

    tearDown(() async {
      await skuRemove(
        client,
        code: 'SKU-TEST$suffix',
      );
    });

    test('test overall', () async {
      {
        final result = await skuUpdate(
          client,
          code: 'SKU-TEST$suffix',
          barcode: '999999999999',
          price: '2222.22',
          quantity: 4444,
        );
        expect(result.rest!.res.statusCode, equals(200));
      }

      {
        final result = await skuRemove(
          client,
          code: 'SKU-TEST$suffix',
        );
        expect(result.rest!.res.statusCode, equals(200));
      }

      {
        final result = await skuRemove(
          client,
          code: 'SKU-TEST$suffix',
        );
        expect(result.rest!.res.statusCode, equals(404));
      }
    });
  });
}

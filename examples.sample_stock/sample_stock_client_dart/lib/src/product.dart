import 'dart:convert';
import 'package:vulcan_client_dart/vulcan_client.dart';
import 'client.dart';

Future<MixResult> productCreate(
  SampleStockClient client, {
  required String name,
}) async {
  final json = {
    'product': {
      'name': name,
    },
  };
  return await client.call(
    MethodType.post,
    client.getUri('product'),
    body: jsonEncode(json),
  );
}

Future<MixResult> productFindAll(
  SampleStockClient client, {
  QueryPage? queryPage,
}) async {
  final query = <String, String>{};
  if (queryPage != null) queryPage.toQueryString(query);
  return await client.call(
    MethodType.get,
    client.getUri('product', query),
  );
}

Future<MixResult> productFindOne(
  SampleStockClient client, {
  required int id,
}) async {
  return await client.call(
    MethodType.get,
    client.getUri('product/$id'),
  );
}

Future<MixResult> productUpdate(
  SampleStockClient client, {
  required int id,
  required List<String> skus,
}) async {
  final json = {
    'product': {},
  };
  final product = json['product']!;
  product['skus'] = skus;
  return await client.call(
    MethodType.put,
    client.getUri('product/$id'),
    body: jsonEncode(json),
  );
}

Future<MixResult> productRemove(
  SampleStockClient client, {
  required int id,
}) async {
  return await client.call(
    MethodType.delete,
    client.getUri('product/$id'),
  );
}

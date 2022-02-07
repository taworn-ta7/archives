import 'dart:convert';
import 'client.dart';
import 'mix_result.dart';
import 'query_page.dart';

Future<MixResult> productCreate(
  Client client, {
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
  Client client, {
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
  Client client, {
  required int id,
}) async {
  return await client.call(
    MethodType.get,
    client.getUri('product/$id'),
  );
}

Future<MixResult> productUpdate(
  Client client, {
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
  Client client, {
  required int id,
}) async {
  return await client.call(
    MethodType.delete,
    client.getUri('product/$id'),
  );
}

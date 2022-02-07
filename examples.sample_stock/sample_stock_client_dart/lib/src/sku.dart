import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vulcan_client_dart/vulcan_client.dart';
import 'client.dart';

Future<MixResult> skuCreate(
  SampleStockClient client, {
  required String code,
  String? barcode,
  required String cost,
  required String price,
  required int? quantity,
}) async {
  final json = {
    'skus': [
      {
        'code': code,
        'barcode': barcode,
        'cost': cost,
        'price': price,
        'quantity': quantity,
      }
    ],
  };
  return await client.call(
    MethodType.post,
    client.getUri('sku'),
    body: jsonEncode(json),
  );
}

Future<MixResult> skuFindAll(
  SampleStockClient client, {
  QueryPage? queryPage,
}) async {
  final query = <String, String>{};
  if (queryPage != null) queryPage.toQueryString(query);
  return await client.call(
    MethodType.get,
    client.getUri('sku', query),
  );
}

Future<MixResult> skuFindOne(
  SampleStockClient client, {
  required String code,
}) async {
  return await client.call(
    MethodType.get,
    client.getUri('sku/$code'),
  );
}

Future<MixResult> skuUpdate(
  SampleStockClient client, {
  required String code,
  String? barcode,
  String? cost,
  String? price,
  int? quantity,
}) async {
  final json = {
    'sku': {},
  };
  final sku = json['sku']!;
  if (barcode != null) sku['barcode'] = barcode;
  if (cost != null) sku['cost'] = cost;
  if (price != null) sku['price'] = price;
  if (quantity != null) sku['quantity'] = quantity;
  return await client.call(
    MethodType.put,
    client.getUri('sku/$code'),
    body: jsonEncode(json),
  );
}

Future<MixResult> skuImageUpload(
  SampleStockClient client, {
  required String code,
  required http.MultipartFile file,
}) async {
  final req = client.prepareMultipart(
    'POST',
    client.getUri('sku/image/$code'),
  );
  req.files.add(file);
  return await client.callMultipart(req);
}

Future<MixResult> skuImageRemove(
  SampleStockClient client, {
  required String code,
}) async {
  return await client.call(
    MethodType.delete,
    client.getUri('sku/image/$code/remove'),
  );
}

Future<MixResult> skuRemove(
  SampleStockClient client, {
  required String code,
}) async {
  return await client.call(
    MethodType.delete,
    client.getUri('sku/$code'),
  );
}

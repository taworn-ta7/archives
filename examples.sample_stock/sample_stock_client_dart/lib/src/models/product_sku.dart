import 'package:json_annotation/json_annotation.dart';
import 'sku.dart';

part 'product_sku.g.dart';

@JsonSerializable()
class ProductSku {
  // id
  int id;

  // product id
  int productId;

  // sku id
  int skuId;

  // sku
  Sku? sku;

  // constructor
  ProductSku({
    this.id = 0,
    required this.productId,
    required this.skuId,
  });

  // from and to JSON
  factory ProductSku.fromJson(Map<String, dynamic> json) =>
      _$ProductSkuFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSkuToJson(this);

  @override
  String toString() => '$id, product=$productId, sku=$skuId';
}

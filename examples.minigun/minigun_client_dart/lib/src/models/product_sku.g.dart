// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_sku.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductSku _$ProductSkuFromJson(Map<String, dynamic> json) => ProductSku(
      id: json['id'] as int? ?? 0,
      productId: json['productId'] as int,
      skuId: json['skuId'] as int,
    )..sku = json['sku'] == null
        ? null
        : Sku.fromJson(json['sku'] as Map<String, dynamic>);

Map<String, dynamic> _$ProductSkuToJson(ProductSku instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'skuId': instance.skuId,
      'sku': instance.sku,
    };

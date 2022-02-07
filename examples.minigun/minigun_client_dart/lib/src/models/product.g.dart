// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: json['id'] as int? ?? 0,
      uid: json['uid'] as String? ?? '',
      name: json['name'] as String? ?? '',
      productSkus: (json['product_skus'] as List<dynamic>?)
          ?.map((e) => ProductSku.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'name': instance.name,
      'product_skus': instance.productSkus,
    };

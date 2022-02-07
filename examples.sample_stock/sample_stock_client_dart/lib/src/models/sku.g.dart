// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sku.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sku _$SkuFromJson(Map<String, dynamic> json) => Sku(
      id: json['id'] as int? ?? 0,
      uid: json['uid'] as String? ?? '',
      code: json['code'] as String? ?? '',
      barcode: json['barcode'] as String?,
      cost: json['cost'] as String? ?? '0.00',
      price: json['price'] as String? ?? '0.00',
      quantity: json['quantity'] as int? ?? 0,
    )..image = json['image'] as String?;

Map<String, dynamic> _$SkuToJson(Sku instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'code': instance.code,
      'barcode': instance.barcode,
      'cost': instance.cost,
      'price': instance.price,
      'quantity': instance.quantity,
      'image': instance.image,
    };

import 'package:json_annotation/json_annotation.dart';
import 'product_sku.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  // id
  int id;

  // link to table users
  String uid;

  // name
  String name;

  // link to sku(s)
  @JsonKey(name: 'product_skus')
  List<ProductSku>? productSkus;

  // constructor
  Product({
    this.id = 0,
    this.uid = '',
    this.name = '',
    this.productSkus,
  });

  // from and to JSON
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
  Map<String, dynamic> toJson() => _$ProductToJson(this);

  @override
  String toString() => '$id, name=$name, sku count=${productSkus?.length}';
}
